import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:szn365/routes/routes_name.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../widgets/app_widget.dart';
import '../../widgets/gradient_background.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.welcome, style: Theme.of(context).appBarTheme.titleTextStyle,),
        backgroundColor: theme.appBarTheme.backgroundColor ?? AppColors.primary,
        elevation: 0,
      ),

      body: GradientBackground(
        child: Padding(padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 50.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/app_logo_3.png', fit: BoxFit.scaleDown,
                alignment: Alignment.center, width: 250.w),

              SizedBox(height: 30.h),
              Text(
                AppStrings.chooseYourGoal,
                style: theme.textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 12.h),
              Text(
                AppStrings.letUsTailorYourPlanToYourFitnessGoal,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),

              // Goal Buttons
              SizedBox(height: 70.h),
              buildAppButton(
                context,
                label: AppStrings.goalLose,
                icon: Icons.trending_down,
                callback: () {
                  context.push(RoutesName.USER_INPUT, extra: AppStrings.goalLose);
                }
              ),

              SizedBox(height: 12.h),
              buildAppButton(
                context,
                label: AppStrings.goalGain,
                icon: Icons.fitness_center,
                callback: () {
                  context.push(RoutesName.USER_INPUT, extra: AppStrings.goalGain);
                }
              ),

              SizedBox(height: 12.h),
              buildAppButton(
                context,
                label: AppStrings.goalMaintain,
                icon: Icons.monitor_heart_outlined,
                callback: () {
                  context.push(RoutesName.USER_INPUT, extra: AppStrings.goalMaintain);
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
