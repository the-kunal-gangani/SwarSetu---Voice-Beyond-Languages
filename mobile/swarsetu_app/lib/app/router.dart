import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/route_constants.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';
import '../features/translation/presentation/screens/translation_screen.dart';

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
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Phrasebook Placeholder'))),
    ),
    GoRoute(
      path: RouteConstants.history,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('History Placeholder'))),
    ),
    GoRoute(
      path: RouteConstants.contribute,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Contribute Placeholder'))),
    ),
    GoRoute(
      path: RouteConstants.settings,
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Settings Placeholder'))),
    ),
  ],
);
