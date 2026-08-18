import 'package:go_router/go_router.dart';
import 'package:swarsetu_app/features/home/home_screen.dart';
import 'package:swarsetu_app/features/splash/splash_screen.dart';
import 'package:swarsetu_app/features/translation/translation_screen.dart';

import '../core/constants/route_constants.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteConstants.splash,

    routes: [
      GoRoute(
        path: RouteConstants.splash,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),

      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: RouteConstants.translate,
        builder: (context, state) {
          return const TranslationScreen();
        },
      ),
    ],
  );
}
