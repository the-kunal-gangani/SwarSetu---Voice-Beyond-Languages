import 'package:go_router/go_router.dart';
import 'package:swarsetu_app/features/contributions/presentation/screens/contribution_screen.dart';
import 'package:swarsetu_app/features/settings/presentation/screens/settings_screen.dart';
import '../core/constants/route_constants.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/translation/presentation/screens/translation_screen.dart';
import '../features/phrasebook/presentation/screens/phrasebook_screen.dart';
import '../features/history/presentation/screens/history_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteConstants.splash,
  routes: [
    GoRoute(
      path: RouteConstants.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RouteConstants.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteConstants.translate,
      builder: (context, state) => const TranslationScreen(),
    ),
    GoRoute(
      path: RouteConstants.phrasebook,
      builder: (context, state) => const PhrasebookScreen(),
    ),
    GoRoute(
      path: RouteConstants.history,
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: RouteConstants.contribute,
      builder: (context, state) => const ContributionScreen(),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
