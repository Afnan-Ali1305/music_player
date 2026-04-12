import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';

final albumsProvider = StateNotifierProvider<AlbumsNotifier, AlbumsState>((ref) {
  return AlbumsNotifier(ref);
});

class AlbumsNotifier extends StateNotifier<AlbumsState> {
  final Ref ref;
  List<AlbumModel> albums = [];

  AlbumsNotifier(this.ref) : super(AlbumsState(albums: []));

  Future<void> fetchAlbums() async {
    final query = OnAudioQuery();
    final loaded = await query.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
    );
    albums = loaded;
    state = state.copyWith(albums: loaded);
  }

  List<Song> getSongsInAlbum(int albumId) {
    final allSongs = ref.read(songsProvider).allSongs;
    return allSongs.where((song) => song.albumId == albumId).toList();
  }
}

class AlbumsState {
  final List<AlbumModel> albums;

  AlbumsState({required this.albums});

  AlbumsState copyWith({List<AlbumModel>? albums}) {
    return AlbumsState(albums: albums ?? this.albums);
  }
}