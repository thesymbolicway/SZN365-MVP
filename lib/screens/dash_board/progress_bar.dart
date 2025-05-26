import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/widgets/animated_progress_indicator.dart';

import '../../utils/colors.dart';

Widget buildProgressBar(BuildContext context,String label, double progress) {
  progress = progress.clamp(0.0, 1.0);

  // Determine emoji and color based on progress
  String emoji;
  Color progressColor;

  if (progress >= 0.75) {
    emoji = '😊';
    progressColor = AppColors.primary;
  } else if (progress >= 0.5) {
    emoji = '😐';
    progressColor = Colors.amber;
  } else {
    emoji = '☹️';
    progressColor = Colors.red;
  }

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12.sp),
      ),
      SizedBox(height: 10.h),
      Stack(
        alignment: Alignment.center,
        children: [
          AnimatedProgressIndicator(targetProgress: progress, progressColor: progressColor),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
              ),
              Text(emoji, style: TextStyle(fontSize: 20.sp)),
            ],
          ),
        ],
      ),
    ],
  );
}
