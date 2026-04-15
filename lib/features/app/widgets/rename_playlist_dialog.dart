// features/music/widgets/playlist/rename_playlist_dialog.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/.playlist.dart';

class RenamePlaylistDialog extends StatefulWidget {
  final Playlist playlist;
  final Function(String newName) onRename;

  const RenamePlaylistDialog({
    super.key,
    required this.playlist,
    required this.onRename,
  });

  @override
  State<RenamePlaylistDialog> createState() => _RenamePlaylistDialogState();
}

class _RenamePlaylistDialogState extends State<RenamePlaylistDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.playlist.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Playlist'),
      content: TextField(
        controller: _controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_controller.text.trim().isNotEmpty) {
              widget.onRename(_controller.text.trim());
            }
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}