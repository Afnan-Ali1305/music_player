import 'package:flutter/material.dart';
import 'package:music_player/core/extensions/app_extensions.dart';

class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: context.textTheme.labelLarge),
        backgroundColor: Colors.white,
      ),
    );
  }
}
