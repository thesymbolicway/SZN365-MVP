import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/routes/routes.dart';
import 'app_theme.dart';

class SznApp extends StatelessWidget {
  const SznApp({super.key});

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/app_logo_3.png'), context);
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'SZN 365',
          themeMode: ThemeMode.dark,
          darkTheme: AppTheme.darkTheme,
          routerConfig: router,
          builder: (context, child) {
            // Fix text scale factor to 1.0
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
              child: child!,
            );
          },
        );
      }
    );
  }
}

