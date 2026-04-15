// features/music/widgets/playlist/add_songs_search.dart
import 'package:flutter/material.dart';
import 'package:music_player/data/models/song.dart';

class AddSongsSearch extends StatefulWidget {
  final List<Song> songs;
  final Function(String songId) onSongTap;

  const AddSongsSearch({
    super.key,
    required this.songs,
    required this.onSongTap,
  });

  @override
  State<AddSongsSearch> createState() => _AddSongsSearchState();
}

class _AddSongsSearchState extends State<AddSongsSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Song> get _filteredSongs {
    if (_searchQuery.isEmpty) return widget.songs;
    
    return widget.songs.where((song) {
      return song.songName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          song.songArtist.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search songs...',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredSongs.isEmpty
              ? const Center(child: Text('No songs found'))
              : ListView.builder(
                  itemCount: _filteredSongs.length,
                  itemBuilder: (context, index) {
                    final song = _filteredSongs[index];
                    return ListTile(
                      title: Text(song.songName),
                      subtitle: Text(song.songArtist),
                      onTap: () => widget.onSongTap(song.songID as String),
                    );
                  },
                ),
        ),
      ],
    );
  }
}