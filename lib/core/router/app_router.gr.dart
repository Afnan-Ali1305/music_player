// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:music_player/features/app/home_screen.dart' as _i2;
import 'package:music_player/features/app/splash_screen.dart' as _i5;
import 'package:music_player/features/music/screens/player_screen.dart'
    as _i4;
import 'package:music_player/features/settings/screens/app_settings.dart'
    as _i1;
import 'package:music_player/features/user/screens/pick_image_screen.dart'
    as _i3;
import 'package:music_player/features/user/screens/user_name_screen.dart'
    as _i6;

/// generated route for
/// [_i1.AppSettingsScreen]
class AppSettingsRoute extends _i7.PageRouteInfo<void> {
  const AppSettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(AppSettingsRoute.name, initialChildren: children);

  static const String name = 'AppSettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppSettingsScreen();
    },
  );
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i7.PageRouteInfo<void> {
  const HomeRoute({List<_i7.PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.HomeScreen();
    },
  );
}

/// generated route for
/// [_i3.PickImageScreen]
class PickImageRoute extends _i7.PageRouteInfo<void> {
  const PickImageRoute({List<_i7.PageRouteInfo>? children})
    : super(PickImageRoute.name, initialChildren: children);

  static const String name = 'PickImageRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i3.PickImageScreen();
    },
  );
}

/// generated route for
/// [_i4.PlayerScreen]
class PlayerRoute extends _i7.PageRouteInfo<void> {
  const PlayerRoute({List<_i7.PageRouteInfo>? children})
    : super(PlayerRoute.name, initialChildren: children);

  static const String name = 'PlayerRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PlayerScreen();
    },
  );
}

/// generated route for
/// [_i5.SplashScreen]
class SplashRoute extends _i7.PageRouteInfo<void> {
  const SplashRoute({List<_i7.PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.SplashScreen();
    },
  );
}

/// generated route for
/// [_i6.UserNameScreen]
class UserNameRoute extends _i7.PageRouteInfo<void> {
  const UserNameRoute({List<_i7.PageRouteInfo>? children})
    : super(UserNameRoute.name, initialChildren: children);

  static const String name = 'UserNameRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.UserNameScreen();
    },
  );
}
