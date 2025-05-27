import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../widgets/gradient_background.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(AppStrings.mealPlan,style:
          Theme.of(context).appBarTheme.titleTextStyle), centerTitle: true),
        body: Padding(
          padding:  EdgeInsets.all(15.w),
          child: Column(
            children: [
              _buildMealPlanCard(context, AppStrings.breakfast,
                  "Scrambled eggs, toast, and coffee",'09:00 AM'),
              SizedBox(height: 16.h),
              _buildMealPlanCard(context,AppStrings.lunch,
                  "Grilled chicken with quinoa and veggies",'01:00 PM'),
              SizedBox(height: 16.h),
              _buildMealPlanCard(context,AppStrings.dinner,
                  "Salmon with sweet potato and salad",'09:00 PM'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealPlanCard(BuildContext context,String mealType, String description,String timeText) {
    return Card(
      elevation: 8.sp,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mealType, style: Theme.of(context).textTheme.labelLarge?.
              copyWith(fontSize: 16.sp)),

             SizedBox(height: 8.h),

            Text(description, style: Theme.of(context).textTheme.bodyMedium?.
              copyWith(fontSize: 14.sp)),

              SizedBox(height: 10.h),

              Row(children: [
                Icon(Icons.access_time, size: 16.w, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(timeText,  style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
