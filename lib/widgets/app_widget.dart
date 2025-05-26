import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required BuildContext context,
  required String label,
  required IconData icon,
  Function(String)? onChanged,
  required String? Function(String?) validator,
  Function()? onTap,
  bool? readOnly,
  FocusNode? focusNode,
  bool canRequestFocus = true,
  bool showDecimal = false,
}) {
  return TextFormField(
    style:  Theme.of(context).textTheme.bodyMedium,
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.bodyMedium,
      focusColor: AppColors.primary,
      prefixIcon: Icon(icon, color: AppColors.primary),
      border: const OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    ),
    keyboardType: TextInputType.numberWithOptions(decimal: showDecimal, signed: false),
    textInputAction: TextInputAction.done,
    readOnly: readOnly ?? false,
    focusNode: focusNode,
    canRequestFocus: canRequestFocus,
    validator: validator,
    onTap: onTap,
    onChanged: onChanged,
    onTapOutside: (_) => FocusScope.of(context).unfocus(),
    onFieldSubmitted: (value) {
      FocusScope.of(context).unfocus();
    },
  );
}

InputDecoration dropdownDecoration({required IconData icon}) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    prefixIcon: Icon(icon, color: AppColors.primary),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 2),
    ),
  );
}

Widget buildAppButton(BuildContext context, {
  required VoidCallback callback,
  required String label,
  IconData? icon,
  bool isLoading = false,
  double height = 43,
  double radius = 14,
}) {
  return GestureDetector(
    onTap: isLoading ? null : callback,
    child: Container(
      width: double.infinity,
      height: height.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.limeGreen,
            AppColors.buttonGradient,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(radius.r),
      ),
      child: Container(
        color: Colors.black.withValues(alpha: 0.2),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: animation,
                child: child,
              ),
            );
          },
          child: !isLoading ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if(icon != null) ...[
              Icon(icon),
              SizedBox(width: 10.w),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ]) : Center(
            key: const ValueKey('loading'), // Important: unique keys for each child
            child: SizedBox(
                width: 23.w,
                height: 23.w,
                child: CircularProgressIndicator(color: AppColors.white)
            )
          ),
        ),
      ),
    ),
  );
}







