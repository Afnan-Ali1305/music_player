import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/data/local/local_storage_service.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/core/router/app_router.gr.dart';
import 'package:music_player/features/user/provider/user_provider.dart';
import 'package:music_player/features/user/widgets/image_picker.dart';

@RoutePage()
class PickImageScreen extends ConsumerStatefulWidget {
  const PickImageScreen({super.key});

  @override
  ConsumerState<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends ConsumerState<PickImageScreen> {
  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.center,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => PickProfilePicture(),
                    );
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[200],
                    child: userState.profilePicture != null
                        ? ClipOval(
                            child: Image.memory(
                              userState.profilePicture!,
                              width: 160,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  context.router.replace(const HomeRoute());
                },
                child: Text(
                  "Save".toUpperCase(),
                  style: context.textTheme.titleLarge!.copyWith(fontSize: 20),
                ),
              ),
              Gap(20),
              ElevatedButton(
                onPressed: () async {
                  await LocalStorage.setVisited();

                  context.router.replace(const HomeRoute());
                },
                child: Text(
                  "Skip".toUpperCase(),
                  style: context.textTheme.titleLarge!.copyWith(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
