import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/Database/local_storage.dart';
import 'package:music_player/extensions/extension_constant.dart';
import 'package:music_player/providers/user_provider.dart';
import 'package:music_player/router/app_router.gr.dart';

@RoutePage()
class UserNameScreen extends ConsumerStatefulWidget {
  const UserNameScreen({super.key});

  @override
  ConsumerState<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends ConsumerState<UserNameScreen> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20),
              Text("Enter Your name: ", style: context.textTheme.titleSmall),
              Gap(10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    ref
                        .read(userProvider.notifier)
                        .saveUser(nameController.text.trim());
                    context.router.replace(const PickImageRoute());
                  } else {
                    debugPrint("Please enter user name");
                  }
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
                  context.router.replace(const PickImageRoute());
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
