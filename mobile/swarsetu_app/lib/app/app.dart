import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_theme.dart';
import 'router.dart';

class SwarSetuApp extends StatelessWidget {
  const SwarSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
