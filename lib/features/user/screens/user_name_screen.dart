import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:music_player/data/local/local_storage_service.dart';
import 'package:music_player/core/extensions/app_extensions.dart';
import 'package:music_player/core/router/app_router.gr.dart';
import 'package:music_player/features/user/provider/user_provider.dart';

@RoutePage()
class UserNameScreen extends ConsumerStatefulWidget {
  const UserNameScreen({super.key});

  @override
  ConsumerState<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends ConsumerState<UserNameScreen> {
  TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
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
              // TextField(
              //   controller: nameController,
              //   decoration: InputDecoration(),
              // ),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(),
                  // onChanged: ,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ("Name is required");
                    }
                    return null;
                  },
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ref
                        .read(userProvider.notifier)
                        .saveUser(nameController.text.trim());
                    context.router.replace(const PickImageRoute());
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
                  if (context.mounted) {
                    context.router.replace(const HomeRoute());
                  }
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
