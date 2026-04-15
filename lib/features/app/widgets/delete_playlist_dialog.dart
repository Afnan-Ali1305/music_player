// features/music/widgets/playlist/delete_playlist_dialog.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/.playlist.dart';

class DeletePlaylistDialog extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onDelete;

  const DeletePlaylistDialog({
    super.key,
    required this.playlist,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Playlist?'),
      content: Text('Delete "${playlist.name}" permanently?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}