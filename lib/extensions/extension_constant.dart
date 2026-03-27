import 'package:flutter/material.dart';

extension BuildContextHelpers on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
}
