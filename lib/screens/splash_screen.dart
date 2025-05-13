import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/gradient_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/boarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: GradientBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 73),
              child: Image.asset(
                'assets/app_logo_3.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
