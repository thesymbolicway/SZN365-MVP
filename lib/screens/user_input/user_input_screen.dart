import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:szn365/models/app_data.dart';
import 'package:szn365/routes/routes_name.dart';
import 'package:szn365/services/firestore_service.dart';
import 'package:go_router/go_router.dart';
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
  final String goal;

  const UserInputScreen({super.key, this.goal = AppStrings.goalMaintain});

  @override
  ConsumerState<UserInputScreen> createState() => _UserInputScreenState();
}

class _UserInputScreenState extends ConsumerState<UserInputScreen> {
  /// Text editing controllers
  final TextEditingController _weightCont = TextEditingController();
  final TextEditingController _heightCont = TextEditingController();
  final TextEditingController _ageCont = TextEditingController();

  /// Focus nodes to control text filed focus
  final FocusNode _ageFocus = FocusNode();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String heightDisplay = AppStrings.height;
  String gender = AppStrings.male;
  double selectedHeightInCm = 0;
  double activityLevel = 1.2;
  bool isHeightValid = true;
  double weight = 0;
  double height = 0;
  int age = 0;

  void _toggleLoading(bool flag) {
    _isLoading = flag;
    setState(() {});
  }

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
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.personalInfo,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(height: 20.h),
                  buildTextField(
                    controller: _weightCont,
                    showDecimal: true,
                    context: context,
                    label: AppStrings.weight,
                    icon: Icons.monitor_weight_outlined,
                    onChanged: (val) {
                      final input = double.tryParse(val) ?? 0;
                      weight = input;
                    },
                    validator: AppValidators.getWeightValidator(
                      errorText: AppStrings.enterValidWeight,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: _heightCont,
                    context: context,
                    label: AppStrings.height,
                    icon: Icons.height,
                    readOnly: true,
                    canRequestFocus: false,
                    onTap: () {
                      showHeightPicker(
                        context: context,
                        initialCmValue: selectedHeightInCm,
                        onHeightSelected: (heightCm) {
                          setState(() {
                            selectedHeightInCm = heightCm;
                            heightDisplay = "${heightCm.toStringAsFixed(2)} cm";
                            height = heightCm;
                            _heightCont.text = heightCm.toStringAsFixed(2);
                            isHeightValid = true;
                            _ageFocus.requestFocus();
                          });
                        },
                      );
                    },
                    validator: AppValidators.getHeightValidatorInCm(
                      errorText: AppStrings.enterValidHeight,
                    ),
                  ),

                  const SizedBox(height: 16),
                  buildTextField(
                    controller: _ageCont,
                    focusNode: _ageFocus,
                    context: context,
                    label: AppStrings.age,
                    icon: Icons.cake_outlined,
                    onChanged: (val) => age = int.tryParse(val) ?? 0,
                    validator: AppValidators.getAgeValidator(
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
                    isLoading: _isLoading,
                    callback: ()  async {
                      setState(() {
                        isHeightValid = selectedHeightInCm > 0;
                      });
                      if (_formKey.currentState!.validate() && isHeightValid) {
                        _toggleLoading(true);
                        final user = AppUser(
                          id: FirebaseAuth.instance.currentUser?.uid,
                          weight: weight.toString(),
                          height: height.toString(),
                          age: age.toString(),
                          gender: gender,
                          activityLevel: activityLevel.toString(),
                          goal: widget.goal,
                        );
                        await userRef.setUser(user);

                        await userRef.getTDECalculation(user);

                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('userId', FireBaseService().getFirebaseUserId()??'');

                        context.go(RoutesName.DASHBOARD);
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
