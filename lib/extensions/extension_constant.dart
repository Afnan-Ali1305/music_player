import 'package:flutter/material.dart';

extension BuildContextHelpers on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}

final class AssetImages {
  static const String iconsPath = 'assets/icons';

  static const String personIcon = '$iconsPath/user.png';
}
