// features/music/widgets/playlist/empty_playlist_detail_view.dart
import 'package:flutter/material.dart';

class EmptyPlaylistDetailView extends StatelessWidget {
  const EmptyPlaylistDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This playlist is empty\nTap + to add songs',
        textAlign: TextAlign.center,
      ),
    );
  }
}