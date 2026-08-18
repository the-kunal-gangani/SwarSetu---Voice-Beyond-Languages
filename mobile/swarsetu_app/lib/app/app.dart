import 'package:flutter/material.dart';
import 'package:swarsetu_app/core/constants/app_theme.dart';

import 'router.dart';
import '../core/constants/app_strings.dart';

class SwarSetuApp extends StatelessWidget {
  const SwarSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      routerConfig: AppRouter.router,
    );
  }
}
