import 'dart:ui';
import 'package:flutter/material.dart';
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

Widget buildAppButton(
    BuildContext context, {
      required VoidCallback callback,
      required String label,
      required IconData icon,
    }) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          AppColors.limeGreen,
          AppColors.buttonGradient,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(14),
    ),
    child: ElevatedButton.icon(
      icon: Icon(icon, size: 24, color: AppColors.white),
      label: Text(
        label,
          style: Theme.of(context).textTheme.bodyMedium,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      onPressed: callback,
    ),
  );
}







