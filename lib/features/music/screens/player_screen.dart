import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

@RoutePage()
class PlayerScreen extends ConsumerWidget {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Adaptive Brand Colors
    final gold = AppColors.brandGold; // #FFC107 - Main accent
    final charcoal = AppColors.brandCharcoal; // #212121
    final textPrimary = isDark ? Colors.white : charcoal;
    final textSecondary = isDark ? Colors.white70 : charcoal.withOpacity(0.75);

    if (songState.currentSong == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Text(
            "No song is playing",
            style: context.textTheme.titleLarge?.copyWith(color: textPrimary),
          ),
        ),
      );
    }

    final currentSong = songState.currentSong!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: textPrimary),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(flex: 1),

              // Album Art
              Center(
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: gold.withOpacity(0.3), width: 12),
                    boxShadow: [
                      BoxShadow(
                        color: gold.withOpacity(0.25),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: QueryArtworkWidget(
                      id: currentSong.songID,
                      type: ArtworkType.AUDIO,
                      artworkWidth: 280,
                      artworkHeight: 280,
                      artworkFit: BoxFit.cover,
                      keepOldArtwork: true,
                      nullArtworkWidget: Container(
                        color: isDark ? charcoal : Colors.grey[200],
                        child: Icon(Icons.music_note, size: 120, color: gold),
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Song Information
              Text(
                currentSong.songName,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                currentSong.songArtist,
                style: context.textTheme.titleMedium?.copyWith(
                  color: textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const Gap(50),

              // Progress Bar
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
                    activeColor: gold,
                    inactiveColor: isDark ? Colors.white24 : Colors.grey[300],
                    thumbColor: gold,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(songState.currentSongPosition),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          _formatDuration(songState.currentSongDuration),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: textSecondary,
                          ),
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
                    icon: Icon(Icons.skip_previous, color: textPrimary),
                    onPressed: () => notifier.previousSong(),
                  ),

                  // Play / Pause Button
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: gold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: gold.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: IconButton(
                      iconSize: 40,
                      icon: songState.isPlaying
                          ? const Icon(Icons.pause, color: Colors.black)
                          : const Icon(Icons.play_arrow, color: Colors.black),
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
                    icon: Icon(Icons.skip_next, color: textPrimary),
                    onPressed: () => notifier.nextSong(),
                  ),
                ],
              ),

              const Gap(20),

              // Repeat & Favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Repeat
                  IconButton(
                    iconSize: 36,
                    icon: Icon(
                      Icons.repeat,
                      color: songState.isRepeat ? gold : textSecondary,
                    ),
                    onPressed: () => notifier.toggleRepeat(),
                  ),

                  // Favorite
                  Consumer(
                    builder: (context, ref, child) {
                      final isLiked =
                          ref
                              .watch(songsProvider)
                              .favouriteMap[currentSong.songID] ??
                          false;
                      return IconButton(
                        iconSize: 36,
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? gold : textSecondary,
                        ),
                        onPressed: () {
                          notifier.toggleFavourite(currentSong.songID);
                        },
                      );
                    },
                  ),
                ],
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
