import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_player/features/user/provider/user_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';
import 'package:music_player/shared/widgets/app_snackbar.dart';

class PickProfilePicture extends ConsumerStatefulWidget {
  const PickProfilePicture({super.key});

  @override
  ConsumerState<PickProfilePicture> createState() => _PickProfilePictureState();
}

class _PickProfilePictureState extends ConsumerState<PickProfilePicture> {
  XFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      title: const Text("Change Account Image"),
      content: Divider(color: AppColors.darkProgressBackground, thickness: 1),
      actions: [
        const SizedBox(height: 10),
        InkWell(
          onTap: () async {
            pickedFile = await ImagePicker().pickImage(
              source: ImageSource.camera, // or ImageSource.camera
              imageQuality: 75,
            );
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.photo_camera,
                  size: 24,
                  color: colorScheme.primary,
                ),
              ),
              const Gap(16),

              // Title
              Expanded(
                child: Text(
                  "Take Photo",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(thickness: 2, height: 25),
        InkWell(
          onTap: () async {
            pickedFile = await ImagePicker().pickImage(
              source: ImageSource.gallery, // or ImageSource.camera
              imageQuality: 75,
            );
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.image, size: 24, color: colorScheme.primary),
              ),
              const Gap(16),
              // Title
              Expanded(
                child: Text(
                  "Chose Photo",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () async {
                context.router.pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (pickedFile != null) {
                  ref.read(userProvider.notifier).savePhoto(pickedFile);
                  context.router.pop();
                } else {
                  AppSnackBar.showError(context, "No image is selected");
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.darkControlPressed,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "save",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
