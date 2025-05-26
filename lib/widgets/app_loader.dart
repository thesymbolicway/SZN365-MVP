import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/utils/colors.dart';

class AppLoader extends StatelessWidget {
  final String text;
  const AppLoader({super.key, this.text = "Loading"});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        height: size.height,
        width: size.width,
        color: AppColors.black.withValues(alpha: 0.7),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          CupertinoActivityIndicator(color: AppColors.primary, radius: 12.w),
          SizedBox(height: 10.h),
          Text("$text...", style: TextStyle(fontSize: 10.sp))
        ])),
      ),
    );
  }
}
