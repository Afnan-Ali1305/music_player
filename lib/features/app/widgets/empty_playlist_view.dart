// features/music/widgets/playlist/empty_playlists_view.dart
import 'package:flutter/material.dart';

class EmptyPlaylistsView extends StatelessWidget {
  const EmptyPlaylistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.queue_music, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text('No playlists yet', style: TextStyle(fontSize: 20)),
          SizedBox(height: 8),
          Text(
            'Create your first playlist!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}