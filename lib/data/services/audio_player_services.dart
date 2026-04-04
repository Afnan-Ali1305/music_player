// import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';

// class MyAudioHandler extends BaseAudioHandler with SeekHandler {
//   final AudioPlayer _player = AudioPlayer();

//   MyAudioHandler() {
//     _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
//     _player.processingStateStream.listen((state) {
//       if (state == ProcessingState.completed) {
//         playbackState.add(playbackState.value.copyWith(
//           processingState: AudioProcessingState.completed,
//         ));
//       }
//     });
//   }

//   @override
//   Future<void> play() => _player.play();

//   @override
//   Future<void> pause() => _player.pause();

//   @override
//   Future<void> stop() async {
//     await _player.stop();
//     await super.stop();
//   }

//   @override
//   Future<void> seek(Duration position) => _player.seek(position);

//   @override
//   Future<void> skipToNext() async {
//     await super.skipToNext();
//   }

//   @override
//   Future<void> skipToPrevious() async {
//     await super.skipToPrevious();
//   }

//   Future<void> playSong(String uri, MediaItem item) async {
//     try {
//       mediaItem.add(item);
//       await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
//       await _player.play();
//     } catch (e) {
//       print('Error playing audio: $e');
//     }
//   }

//   Stream<Duration> get positionStream => _player.positionStream;

//   Stream<Duration?> get durationStream => _player.durationStream;

//   Stream<PlayerState> get playerStateStream => _player.playerStateStream;

//   PlaybackState _transformEvent(PlaybackEvent event) {
//     return PlaybackState(
//       controls: [
//         MediaControl.skipToPrevious, 
//         if (_player.playing) MediaControl.pause else MediaControl.play,
//         MediaControl.skipToNext, 
//         MediaControl.stop, 
//       ],

//       systemActions: const {
//         MediaAction.seek,           
//         MediaAction.seekForward,    
//         MediaAction.seekBackward,  
//         MediaAction.skipToNext,
//         MediaAction.skipToPrevious,
//         MediaAction.playPause,
//       },

//       androidCompactActionIndices: const [0, 1, 2], 

//       processingState: const {
//         ProcessingState.idle: AudioProcessingState.idle,
//         ProcessingState.loading: AudioProcessingState.loading,
//         ProcessingState.buffering: AudioProcessingState.buffering,
//         ProcessingState.ready: AudioProcessingState.ready,
//         ProcessingState.completed: AudioProcessingState.completed,
//       }[_player.processingState]!,

//       playing: _player.playing,

//       updatePosition: _player.position,

//       speed: _player.speed,

//       updateTime: event.updateTime,

//       bufferedPosition: _player.bufferedPosition,
//     );
//   }

//   @override
//   Future<void> onTaskRemoved() async {
//     await _player.stop();
//     await _player.dispose();
//     await super.onTaskRemoved();
//   }
// }

import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

// MyAudioHandler extends BaseAudioHandler which is the bridge between
// your app and the system's media session (notification + lock screen).
//
// How it works:
// - audio_service registers a long-running background service
// - The OS communicates with it via MediaSession (Android) / MPRemoteCommandCenter (iOS)
// - BaseAudioHandler translates those OS commands into our method calls
// - We use just_audio under the hood as the actual audio engine
//
// THE FIX: We expose callback functions (onSkipToNext, onSkipToPrevious,
// onSongComplete) so that SongsNotifier can register its own logic here.
// When the notification next/prev buttons are tapped, the handler fires
// these callbacks which run the actual queue logic in the provider.
class MyAudioHandler extends BaseAudioHandler with SeekHandler {
  // The actual audio engine — just_audio handles decoding and playback
  final AudioPlayer _player = AudioPlayer();

  // ================= CALLBACKS =================
  // These are set by SongsNotifier after initialization so the handler
  // can call back into the provider when notification buttons are tapped
  // or when a song completes naturally.

  // Called when the user taps "next" on the notification or lock screen,
  // or when a song finishes and autoplay should advance the queue.
  VoidCallback? onSkipToNext;

  // Called when the user taps "previous" on the notification or lock screen
  VoidCallback? onSkipToPrevious;

  // Called when the current song completes naturally (not skipped).
  // SongsNotifier uses this to handle repeat mode vs autoplay.
  VoidCallback? onSongComplete;

  MyAudioHandler() {
    // Forward just_audio's playback events to audio_service's playbackState
    // stream so the notification UI stays in sync with the player state
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // Listen for natural song completion and fire the onSongComplete callback.
    // This is what drives autoplay — when a song ends, the provider decides
    // whether to repeat or advance to the next song in the queue.
    _player.processingStateStream.listen((processingState) {
      if (processingState == ProcessingState.completed) {
        // Update notification state to reflect completion
        playbackState.add(playbackState.value.copyWith(
          processingState: AudioProcessingState.completed,
        ));

        // Fire the callback so SongsNotifier can handle repeat vs next song
        onSongComplete?.call();
      }
    });
  }

  // ================= PLAYBACK CONTROLS =================
  // These are called by the system (notification buttons, lock screen,
  // Bluetooth headset buttons, Google Assistant) as well as by our own UI.

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    // Notify audio_service so it can clean up the notification
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Called when the user taps "next" on the notification or lock screen.
  // We fire the onSkipToNext callback which runs nextSong() in SongsNotifier.
  @override
  Future<void> skipToNext() async {
    // Fire the callback FIRST so the queue advances immediately
    onSkipToNext?.call();

    // Then call super so audio_service updates the media session state
    await super.skipToNext();
  }

  // Called when the user taps "previous" on the notification or lock screen.
  // We fire the onSkipToPrevious callback which runs previousSong() in SongsNotifier.
  @override
  Future<void> skipToPrevious() async {
    // Fire the callback FIRST so the queue goes back immediately
    onSkipToPrevious?.call();

    // Then call super so audio_service updates the media session state
    await super.skipToPrevious();
  }

  // ================= PLAY A SPECIFIC SONG =================
  // Called from SongsNotifier whenever a new song is selected.
  // Updates the notification metadata (title, artist) before playing.
  Future<void> playSong(String uri, MediaItem item) async {
    try {
      // Update the notification / lock screen metadata BEFORE playing
      // so the user sees the correct song name immediately
      mediaItem.add(item);

      // Load the audio source from the local file URI
      await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));

      // Start playback
      await _player.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  // ================= STREAMS =================
  // Exposed to SongsNotifier so it can track position, duration, and state

  // Emits the current playback position roughly every 200ms while playing
  Stream<Duration> get positionStream => _player.positionStream;

  // Emits the total duration of the current song once it is known
  Stream<Duration?> get durationStream => _player.durationStream;

  // Emits the full player state including processingState (loading/buffering/completed)
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // ================= STATE TRANSFORMER =================
  // Converts just_audio's PlaybackEvent into audio_service's PlaybackState.
  // This drives the notification UI — which buttons show, seek bar progress, etc.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      // Buttons shown in the expanded notification
      controls: [
        MediaControl.skipToPrevious, // Previous button
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,     // Next button
        MediaControl.stop,           // Stop button
      ],

      // Actions available via the media session (Bluetooth, Android Auto, etc.)
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
        MediaAction.playPause,
      },

      // Indices of controls[] to show in the compact (collapsed) notification.
      // Limited to 3 slots: previous, play/pause, next
      androidCompactActionIndices: const [0, 1, 2],

      // Map just_audio processing state to audio_service processing state
      processingState: const {
        ProcessingState.idle:      AudioProcessingState.idle,
        ProcessingState.loading:   AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready:     AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,

      // Current playing status
      playing: _player.playing,

      // Current position — drives the seek bar in the notification
      updatePosition: _player.position,

      // Playback speed — used by the system to animate the seek bar
      speed: _player.speed,

      // Timestamp for position interpolation between stream updates
      updateTime: event.updateTime,

      // How much audio has been buffered ahead
      bufferedPosition: _player.bufferedPosition,
    );
  }

  // ================= CLEANUP =================
  // Called when the user swipes away the app from recents or the OS kills it
  @override
  Future<void> onTaskRemoved() async {
    await _player.stop();
    await _player.dispose();
    await super.onTaskRemoved();
  }
}