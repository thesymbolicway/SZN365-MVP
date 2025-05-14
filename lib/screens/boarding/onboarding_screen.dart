import 'package:flutter/material.dart';
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Center(child:  Text(AppStrings.welcome, style: Theme.of(context).appBarTheme.titleTextStyle,)),
        backgroundColor: theme.appBarTheme.backgroundColor ?? AppColors.primary,
        foregroundColor: theme.appBarTheme.foregroundColor ?? AppColors.white,
        elevation: 0,
      ),

      body: GradientBackground(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Image.asset(
                  'assets/app_logo_3.png',
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
              ),
            ),
            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   color: Colors.black,
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 50),
            //     child: Image.asset(
            //       'assets/app_logo_2.jpg',
            //       fit: BoxFit.scaleDown,
            //       alignment: Alignment.center,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    const SizedBox(height: 24),
                     Text(
                      AppStrings.chooseYourGoal,
                      style: theme.textTheme.labelLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                     Text(
                      AppStrings.letUsTailorYourPlanToYourFitnessGoal,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 100),

                    // Goal Buttons
                    buildAppButton(
                        context,
                        label: AppStrings.goalLose,
                        icon: Icons.trending_down,
                        callback: () {
                          Navigator.pushNamed(
                            context, '/input', arguments: AppStrings.goalLose,);
                        }
                    ),
                    const SizedBox(height: 16),
                    buildAppButton(
                        context,
                        label: AppStrings.goalGain,
                        icon: Icons.fitness_center,
                        callback: () {
                          Navigator.pushNamed(
                            context, '/input', arguments: AppStrings.goalGain,);
                        }
                    ),
                    const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }


}
