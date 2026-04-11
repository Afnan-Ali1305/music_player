import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/features/settings/providers/theme_provider.dart';
import 'package:music_player/features/settings/widgets/settings_section_header.dart';
import 'package:music_player/features/user/provider/user_provider.dart';
import 'package:music_player/features/user/widgets/edit_user_name.dart';
import 'package:music_player/features/user/widgets/image_picker.dart';
import 'package:music_player/features/settings/widgets/privacy_policy.dart';
import 'package:music_player/features/settings/widgets/settings_row.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(
      themeProvider.select((state) => state.isDarkMode),
    );
    final userName = ref.watch(userProvider.select((state) => state.userName));
    final profilePicture = ref.watch(
      userProvider.select((state) => state.profilePicture),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Center(
              child: Column(
                children: [
                  // const ProfileImagePicker(),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[200],
                    child: profilePicture != null
                        ? ClipOval(
                            child: Image.memory(
                              profilePicture,
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
                  const Gap(16),
                  Text(
                    userName ?? "Musify", // You can make this dynamic later
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(30),

            // Music Preferences
            SettingsSectionHeader(title: "Profile"),
            const Gap(12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SettingsRow(
                    text: "Edit Name",
                    icon: Icons.edit, // Replace with scan icon later
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => const EditUserName(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    text: "Change Image",
                    icon: Icons.camera_alt,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PickProfilePicture(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Gap(17),

            // Appearance
            SettingsSectionHeader(title: "Appearance"),
            const Gap(12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SettingsRow(
                text: "Dark Mode",
                icon: Icons.dark_mode, // Replace with theme icon
                trailing: Switch(
                  value: darkMode,
                  // activeColor: colorScheme.primary,
                  onChanged: (value) {
                    ref.read(themeProvider.notifier).changeTheme();
                  },
                ),
                onTap: () {
                  ref.read(themeProvider.notifier).changeTheme();
                },
              ),
            ),

            const Gap(17),

            // App Info
            SettingsSectionHeader(title: "About"),
            const Gap(12),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SettingsRow(
                    text: "App Version",
                    icon: Icons.info,
                    trailing: const Text("1.0.0"),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    text: "Developed By",
                    icon: Icons.group,
                    trailing: const Text("Afnan Ali"),
                  ),
                  const Divider(height: 1),
                  SettingsRow(
                    text: "Privacy Policy",
                    icon: Icons.privacy_tip,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => PrivacyPolicy(),
                      );
                    },
                  ),
                ],
              ),
            ),

            const Gap(40),

            // Logout / Extra
            // Center(
            //   child: TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       "Clear Cache & Data",
            //       style: TextStyle(
            //         color: Colors.redAccent,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSectionTitle(BuildContext context, String title) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 8),
  //     child: Text(
  //       title,
  //       style: context.textTheme.titleSmall?.copyWith(
  //         fontWeight: FontWeight.w600,
  //         letterSpacing: 0.6,
  //         color: Theme.of(context).colorScheme.onSurfaceVariant,
  //       ),
  //     ),
  //   );
  // }
}
