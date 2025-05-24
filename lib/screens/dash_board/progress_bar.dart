import 'package:flutter/material.dart';

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
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 5),
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 6,
              backgroundColor: Colors.grey[300],
              color: progressColor,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(emoji, style: const TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    ],
  );
}
