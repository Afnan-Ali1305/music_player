import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/providers/songs_provider.dart'; // Your provider file
import 'package:music_player/providers/theme_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

@RoutePage()
class PlayerScreen extends ConsumerWidget {
  // Changed to ConsumerWidget (simpler)
  const PlayerScreen({super.key});

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songState = ref.watch(songsProvider);
    final notifier = ref.read(songsProvider.notifier);
    final themeState = ref.watch(themeProvider);
    // Safety check
    if (songState.currentSong == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No song is playing",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    final currentSong = songState.currentSong!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Album Art (Static - No unwanted rotation)
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 8),
                  ),
                  child: ClipOval(
                    child: QueryArtworkWidget(
                      id: currentSong.songID,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 280,
                      artworkHeight: 280,
                      artworkFit: BoxFit.cover,
                      nullArtworkWidget: Container(
                        color: Colors.grey[900],
                        child: const Icon(
                          Icons.music_note,
                          size: 120,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Song Information
              Text(
                currentSong.songName,
                style: context.textTheme.titleLarge,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                currentSong.songArtist,
                style: context.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),

              const Gap(50),

              // Progress Bar + Time (Now using Riverpod state)
              Column(
                children: [
                  Slider(
                    value: songState.currentSongPosition.inSeconds
                        .toDouble()
                        .clamp(
                          0,
                          songState.currentSongDuration.inSeconds.toDouble() > 0
                              ? songState.currentSongDuration.inSeconds
                                    .toDouble()
                              : 1,
                        ),
                    max: songState.currentSongDuration.inSeconds.toDouble() > 0
                        ? songState.currentSongDuration.inSeconds.toDouble()
                        : 1,
                    onChanged: (value) {
                      notifier.seekTo(Duration(seconds: value.toInt()));
                    },
                    activeColor: themeState.isDarkMode
                        ? Colors.white
                        : Colors.black,
                    inactiveColor: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(songState.currentSongPosition),
                          style: context.textTheme.labelLarge,
                        ),
                        Text(
                          _formatDuration(songState.currentSongDuration),
                          style: context.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Playback Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Previous
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => notifier.previousSong(),
                  ),

                  // Play / Pause Button
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: themeState.isDarkMode
                          ? Colors.white
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 40,
                      icon: songState.isPlaying
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow),
                      onPressed: () {
                        if (songState.isPlaying) {
                          notifier.pauseSong();
                        } else {
                          notifier.resumeSong();
                        }
                      },
                    ),
                  ),

                  // Next
                  IconButton(
                    iconSize: 48,
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => notifier.nextSong(),
                  ),

                  // Repeat
                ],
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.repeat),
                    onPressed: () {
                      // Add repeat logic later if needed
                      notifier.nextSong();
                    },
                  ),

                  // Favorite
                  IconButton(
                    iconSize: 36,
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Add favorite logic later if needed
                    },
                  ),
                ],
              ),
              Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
