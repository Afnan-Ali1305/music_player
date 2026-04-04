import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/extensions/app_extensions.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Privacy Policy"),
          IconButton(
            onPressed: () {
              context.router.pop();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),

      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Text('''
We respect your privacy.

1. Data Collection
This app only accesses the data you explicitly allow. We do not collect any personal data without your permission.

2. Permissions
We access storage only to play music files from your device.

3. Data Usage
Your data stays on your device. We do not upload anything.

4. Security
We do not share your data with any third party.

5. Contact
Gmail: Afnanali1305@gmail.com
Phone No: 03280241305
              ''', style: context.textTheme.titleMedium),
        ),
      ),
    );
  }
}
