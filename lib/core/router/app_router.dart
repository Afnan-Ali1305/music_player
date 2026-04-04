import 'package:auto_route/auto_route.dart';
import 'package:music_player/core/router/app_router.gr.dart';

// dart run build_runner build
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      page: SplashRoute.page,
      initial: true,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: UserNameRoute.page,
    ),
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.fadeIn,
      page: HomeRoute.page,
    ),
    CustomRoute(
      page: AppSettingsRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: PlayerRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      page: PickImageRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
  ];
}
