import 'dart:typed_data';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
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
          profilePicture: LocalStorage.getProfileImage(),
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

  Future<void> savePhoto(XFile? pickedFile) async {
    if (pickedFile == null) return;
    final bytes = await pickedFile.readAsBytes();
    state = state.copyWith(profilePicture: bytes);
    await LocalStorage.setProfileImage(bytes);
  }

  // Delete profile image
  Future<void> deleteImage() async {
    state = state.copyWith(profilePicture: null);
    await LocalStorage.deleteProfileImage();
  }
}

class UserState {
  final String? userName;
  final bool isFirstTime;

  final Uint8List? profilePicture;
  UserState({this.userName, required this.isFirstTime, this.profilePicture});

  UserState copyWith({
    String? userName,
    bool? isFirstTime,
    Uint8List? profilePicture,
  }) {
    return UserState(
      userName: userName ?? this.userName,
      isFirstTime: isFirstTime ?? this.isFirstTime,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }
}
