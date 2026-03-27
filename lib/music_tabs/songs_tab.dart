import 'package:flutter/material.dart';

class SongsTab extends StatefulWidget {
  final List allSongs;
  const SongsTab({super.key, required this.allSongs});

  @override
  State<SongsTab> createState() => _SongsTabState();
}

class _SongsTabState extends State<SongsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: widget.allSongs.length, // Replace with your songs provider length
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note, color: Colors.white70),
          ),
          title: Text("Local Song ${index + 1}"),
          subtitle: const Text("Artist • 3:45"),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
          onTap: () {
            // TODO: Play song using your audio player provider
          },
        );
      },
    );
  }
}
