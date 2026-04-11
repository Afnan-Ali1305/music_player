import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/features/user/provider/user_provider.dart';
import 'package:music_player/core/theme/app_colors.dart';

class EditUserName extends ConsumerStatefulWidget {
  const EditUserName({super.key});

  @override
  ConsumerState<EditUserName> createState() => _EditUserNameState();
}

class _EditUserNameState extends ConsumerState<EditUserName> {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Account Name"),
      content: Divider(color: AppColors.darkProgressBackground, thickness: 1),
      actions: [
        Form(
          key: formKey,
          child: TextFormField(
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name is Required";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: "Enter Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(
                  width: 1,
                  color: AppColors.darkProgressBackground,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
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
                if (formKey.currentState!.validate()) {
                  ref
                      .read(userProvider.notifier)
                      .updateUser(nameController.text.trim());
                  context.router.pop();
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
                child: Text(
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
