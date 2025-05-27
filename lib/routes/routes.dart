import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:szn365/routes/routes_name.dart';
import 'package:szn365/screens/food_selection/food_selection_screen.dart';
import 'package:szn365/screens/meal_plan/meal_plan_screen.dart';
import '../screens/dash_board/dashboard_screen.dart';
import '../screens/user_input/user_input_screen.dart';
import '../screens/boarding/onboarding_screen.dart';
import '../screens/splash/splash_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: RoutesName.SPLASH,
  routes: [
    GoRoute(path: RoutesName.SPLASH,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const SplashScreen()),
    ),

    GoRoute(path: RoutesName.BOARDING,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const OnboardingScreen()),
    ),

    GoRoute(path: RoutesName.DASHBOARD,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const DashboardScreen()),
    ),

    GoRoute(path: RoutesName.USER_INPUT,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey,
        child: UserInputScreen(goal: state.extra as String)),
    ),

    GoRoute(path: RoutesName.FOOD_SELECTION,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey,
        child: FoodSelectionScreen(mealType: state.extra as String)),
    ),

    GoRoute(path: RoutesName.MEAL_PLAN,
      pageBuilder: (context, state) => CupertinoPage(key: state.pageKey, child: const MealPlanScreen()),
    ),
  ],
);

