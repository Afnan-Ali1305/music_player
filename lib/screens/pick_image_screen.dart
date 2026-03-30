import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/providers/user_provider.dart';
import 'package:music_player/router/app_router.gr.dart';
import 'package:music_player/widgets/image_picker.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 20),
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
                  context.router.push(const HomeRoute());
                },
                child: Text("Save", style: context.textTheme.titleLarge),
              ),
              Gap(20),
              ElevatedButton(
                onPressed: () {
                  context.router.push(const HomeRoute());
                },
                child: Text("Skip", style: context.textTheme.titleLarge),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
