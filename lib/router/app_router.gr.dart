// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:music_player/screens/app_settings.dart' as _i1;
import 'package:music_player/screens/home_screen.dart' as _i2;
import 'package:music_player/screens/splash_screen.dart' as _i3;
import 'package:music_player/screens/user_name_screen.dart' as _i4;

/// generated route for
/// [_i1.AppSettingsScreen]
class AppSettingsRoute extends _i5.PageRouteInfo<void> {
  const AppSettingsRoute({List<_i5.PageRouteInfo>? children})
    : super(AppSettingsRoute.name, initialChildren: children);

  static const String name = 'AppSettingsRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.SplashScreen]
class SplashRoute extends _i5.PageRouteInfo<void> {
  const SplashRoute({List<_i5.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i3.SplashScreen();
    },
  );
}

/// generated route for
/// [_i4.UserNameScreen]
class UserNameRoute extends _i5.PageRouteInfo<void> {
  const UserNameRoute({List<_i5.PageRouteInfo>? children})
    : super(UserNameRoute.name, initialChildren: children);

  static const String name = 'UserNameRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.UserNameScreen();
    },
  );
}
