import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/data/local/local_storage_service.dart';
import 'package:music_player/data/models/song.dart';
import 'package:music_player/features/music/providers/songs_provider.dart';
// To access allSongs

final favouritesProvider = StateNotifierProvider<FavouritesNotifier, FavouritesState>((ref) {
  return FavouritesNotifier(ref);
});

class FavouritesNotifier extends StateNotifier<FavouritesState> {
  final Ref ref;

  FavouritesNotifier(this.ref) : super(FavouritesState(favouriteMap: {})) {
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    final map = LocalStorage.getFavouriteMap();
    state = state.copyWith(favouriteMap: map);
  }

  void toggleFavourite(int songID) async {
    final current = state.favouriteMap[songID] ?? false;
    final newMap = {...state.favouriteMap, songID: !current};

    state = state.copyWith(favouriteMap: newMap);
    await LocalStorage.setFavouriteMap(newMap);
  }

  List<Song> get favouriteSongs {
    final allSongs = ref.read(songsProvider).allSongs;
    return allSongs.where((song) => state.favouriteMap[song.songID] == true).toList();
  }
}

class FavouritesState {
  final Map<int, bool> favouriteMap;

  FavouritesState({required this.favouriteMap});

  FavouritesState copyWith({Map<int, bool>? favouriteMap}) {
    return FavouritesState(favouriteMap: favouriteMap ?? this.favouriteMap);
  }
}