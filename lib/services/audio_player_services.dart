import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  // Singleton pattern so only one player exists in the app
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  // Play a specific song by its URI (path)
  Future<void> playSong(String uri) async {
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(uri)));
      _player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  void pause() => _player.pause();
  void resume() => _player.play();
  void stop() => _player.stop();

  void seek(Duration position) {
    _player.seek(position);
  }

  // Streams
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // Dispose the player when the app is closed
  void dispose() => _player.dispose();
}
