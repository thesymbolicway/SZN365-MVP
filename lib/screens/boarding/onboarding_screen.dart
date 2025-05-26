import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: AppColors.textLight,
      appBar: AppBar(
        title: Text(AppStrings.welcome, style: Theme.of(context).appBarTheme.titleTextStyle,),
        backgroundColor: theme.appBarTheme.backgroundColor ?? AppColors.primary,
        foregroundColor: theme.appBarTheme.foregroundColor ?? AppColors.white,
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
                  Navigator.pushNamed(
                    context, '/input', arguments: AppStrings.goalLose,);
                }
              ),

              SizedBox(height: 12.h),
              buildAppButton(
                context,
                label: AppStrings.goalGain,
                icon: Icons.fitness_center,
                callback: () {
                  Navigator.pushNamed(
                    context, '/input', arguments: AppStrings.goalGain,);
                }
              ),

              SizedBox(height: 12.h),
              buildAppButton(
                  context,
                  label: AppStrings.goalMaintain,
                  icon: Icons.monitor_heart_outlined,
                  callback: () {
                    Navigator.pushNamed(
                      context, '/input', arguments: AppStrings.goalMaintain,);
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
