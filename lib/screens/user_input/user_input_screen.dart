import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:szn365/models/app_data.dart';
import '../../consts/constant.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../utils/validators.dart';
import '../../widgets/app_widget.dart';
import '../../widgets/gradient_background.dart';
import 'height_picker_bottom_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInputScreen extends ConsumerStatefulWidget {
  String goal = AppStrings.goalMaintain;

  UserInputScreen({super.key, required this.goal});

  @override
  ConsumerState<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends ConsumerState<UserInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String heightDisplay = AppStrings.height;
  String gender = AppStrings.male;
  double selectedHeightInCm = 0;
  double activityLevel = 1.2;
  bool isHeightValid = true;
  double weight = 0;
  double height = 0;
  int age = 0;

  @override
  Widget build(BuildContext context) {
    final userRef = ref.read(userProvider.notifier);
    final theme = Theme.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            AppStrings.tellUsAboutYou,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          backgroundColor:
              theme.appBarTheme.backgroundColor ?? AppColors.primary,
          foregroundColor: theme.appBarTheme.foregroundColor ?? AppColors.white,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.personalInfo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    context: context,
                    label: AppStrings.weight,
                    icon: Icons.monitor_weight_outlined,
                    onChanged: (val) {
                      final input = double.tryParse(val) ?? 0;
                      weight = input;
                    },
                    validator: AppValidators.getValidator(
                      errorText: AppStrings.enterValidWeight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      showHeightPicker(
                        context: context,
                        initialCmValue: selectedHeightInCm,
                        onHeightSelected: (heightCm) {
                          setState(() {
                            selectedHeightInCm = heightCm;
                            heightDisplay = "${heightCm.toStringAsFixed(1)} cm";
                            height = heightCm;
                            isHeightValid = true;
                          });
                        },
                      );
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: AppStrings.height,
                        prefixIcon: Icon(
                          Icons.height,
                          color: AppColors.primary,
                        ),
                        hintText: heightDisplay,
                        errorText:
                            isHeightValid ? null : AppStrings.enterValidHeight,
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        heightDisplay,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  buildTextField(
                    context: context,
                    label: AppStrings.age,
                    icon: Icons.cake_outlined,
                    onChanged: (val) => age = int.tryParse(val) ?? 0,
                    validator: AppValidators.getValidator(
                      errorText: AppStrings.enterValidAge,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.selectGender,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: gender,
                    decoration: dropdownDecoration(icon: Icons.person_outline),
                    items: const [
                      DropdownMenuItem(
                        value: AppStrings.male,
                        child: Text(AppStrings.maleM),
                      ),
                      DropdownMenuItem(
                        value: AppStrings.female,
                        child: Text(AppStrings.femaleF),
                      ),
                    ],
                    onChanged: (val) => setState(() => gender = val!),
                    menuMaxHeight: 250, // Optional max height for dropdown
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppStrings.activityLevel,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<double>(
                    value: activityLevel,
                    decoration: dropdownDecoration(icon: Icons.fitness_center),
                    items: const [
                      DropdownMenuItem(
                        value: Constant.sedentary,
                        child: Text(AppStrings.sedentary),
                      ),
                      DropdownMenuItem(
                        value: Constant.lightlyActive,
                        child: Text(AppStrings.lightlyActive),
                      ),
                      DropdownMenuItem(
                        value: Constant.moderatelyActive,
                        child: Text(AppStrings.moderatelyActive),
                      ),
                      DropdownMenuItem(
                        value: Constant.veryActive,
                        child: Text(AppStrings.veryActive),
                      ),
                      DropdownMenuItem(
                        value: Constant.extraActive,
                        child: Text(AppStrings.extraActive),
                      ),
                    ],
                    onChanged: (val) => setState(() => activityLevel = val!),
                  ),
                  const SizedBox(height: 30),
                  buildAppButton(
                    context,
                    label: AppStrings.continueText,
                    icon: Icons.arrow_forward,
                    callback: ()  {
                      setState(() {
                        isHeightValid = selectedHeightInCm > 0;
                      });
                      if (_formKey.currentState!.validate() && isHeightValid) {

                        final user = AppUser(
                          id: FirebaseAuth.instance.currentUser?.uid,
                          weight: weight.toString(),
                          height: height.toString(),
                          age: age.toString(),
                          gender: gender,
                          activityLevel: activityLevel.toString(),
                          goal: widget.goal,
                        );

                         userRef.setUser(user);
                        userRef.getTDECalculation(user);

                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showHeightPicker({
    required BuildContext context,
    required double initialCmValue,
    required Function(double heightInCm) onHeightSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkBackground,
      builder:
          (_) => HeightPickerBottomSheet(
            initialCmValue: initialCmValue,
            onHeightSelected: onHeightSelected,
          ),
    );
  }
}
