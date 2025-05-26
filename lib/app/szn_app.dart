import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/routes/routes.dart';
import 'app_theme.dart';

class SznApp extends StatelessWidget {
  const SznApp({super.key});

  @override
  Widget build(BuildContext context) {
      return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SZN 365',
            theme: AppTheme.darkTheme,
            initialRoute: '/',
            onGenerateRoute: onGenerateRoute,
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

