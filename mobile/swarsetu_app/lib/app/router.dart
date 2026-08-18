import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/translate',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Translate Screen Placeholder')),
      ),
    ),
    GoRoute(
      path: '/phrasebook',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Phrasebook Placeholder'))),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('History Placeholder'))),
    ),
    GoRoute(
      path: '/contribute',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Contribute Placeholder'))),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Settings Placeholder'))),
    ),
  ],
);
