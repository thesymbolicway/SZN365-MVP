import 'package:flutter/material.dart';
import 'package:szn365/routes/routes.dart';
import 'app_theme.dart';

class SznApp extends StatelessWidget {
  const SznApp({super.key});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SZN 365',
        theme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: appRoutes,
      );
    }
  }

