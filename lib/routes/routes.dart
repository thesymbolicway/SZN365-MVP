import 'package:flutter/material.dart';

import '../screens/dash_board/dashboard_screen.dart';
import '../screens/user_input/user_input_screen.dart';
import '../screens/boarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/boarding': (context) => const OnboardingScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/input': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as String;
    return UserInputScreen(goal: args);
  },
};
