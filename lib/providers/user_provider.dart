import 'package:flutter_riverpod/legacy.dart';
import 'package:music_player/Database/local_storage.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier()
    : super(
        UserState(
          isFirstTime: LocalStorage.isFirstTime(),
          userName: LocalStorage.getUsername(),
        ),
      );

  Future<void> saveUser(String name) async {
    await LocalStorage.setUsername(name);
    await LocalStorage.setVisited();

    state = state.copyWith(isFirstTime: false, userName: name);
  }

  Future<void> updateUser(String name) async {
    await LocalStorage.updateUsername(name);

    state = state.copyWith(userName: name);
  }
}

class UserState {
  final String? userName;
  final bool isFirstTime;
  UserState({this.userName, required this.isFirstTime});

  UserState copyWith({String? userName, bool? isFirstTime}) {
    return UserState(
      userName: userName ?? this.userName,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}
