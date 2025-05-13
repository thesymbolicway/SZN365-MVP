import 'package:flutter/material.dart';

import '../utils/colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.darkGradient,
      ),
      child: child,
    );
  }
}
