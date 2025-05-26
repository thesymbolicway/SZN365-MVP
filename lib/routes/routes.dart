import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/dash_board/dashboard_screen.dart';
import '../screens/meal_plan/meal_plan_screen.dart';
import '../screens/user_input/user_input_screen.dart';
import '../screens/boarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return CupertinoPageRoute(builder: (_) => const SplashScreen());
    case '/boarding':
      return CupertinoPageRoute(builder: (_) => const OnboardingScreen());
    case '/dashboard':
      return CupertinoPageRoute(builder: (_) => const DashboardScreen());
    case '/meal_plan':
      return CupertinoPageRoute(builder: (_) => const MealPlanScreen());
    case '/input':
      final args = settings.arguments as String;
      return CupertinoPageRoute(builder: (_) => UserInputScreen(goal: args));
    default:
      return CupertinoPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('Route not found')),
        ),
      );
  }
}

