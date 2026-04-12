import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/features/music/providers/playlists_provider.dart';

class CreatePlaylist extends ConsumerStatefulWidget {
  const CreatePlaylist({super.key});

  @override
  ConsumerState<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends ConsumerState<CreatePlaylist> {
  TextEditingController playListName = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Playlist'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: playListName,
          decoration: const InputDecoration(hintText: 'Playlist name'),
          autofocus: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Playlist name is required";
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => context.router.pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              ref
                  .read(playlistsProvider.notifier)
                  .createPlaylist(playListName.text.trim());
              context.router.pop();
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
