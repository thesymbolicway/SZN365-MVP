import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/widgets/app_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:go_router/go_router.dart';
import '../../models/food_entry.dart';
import '../../providers/food_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';


class AddFoodBottomSheet extends ConsumerStatefulWidget {
  const AddFoodBottomSheet({super.key});

  @override
  ConsumerState<AddFoodBottomSheet> createState() => _AddFoodBottomSheetState();
}

class _AddFoodBottomSheetState extends ConsumerState<AddFoodBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();
  final caloriesController = TextEditingController();

  bool _isLoading = false;

  void _toggleLoading(bool flag) {
    _isLoading = flag;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: AppColors.primary.withValues(alpha: 0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );

    return Padding(
      padding: MediaQuery.of(context).viewInsets.add(EdgeInsets.only(
          left: 16.w, right: 16.w, bottom: (bottomPadding + 10.h), top: 16.h)),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Wrap(
            runSpacing: 16,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppColors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text(
                AppStrings.addFoodEntry,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 25.h),
              TextFormField(
                style:  Theme.of(context).textTheme.bodyMedium,
                controller: nameController,
                decoration: inputDecoration.copyWith(
                  labelText: AppStrings.foodName,
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: const Icon(Icons.fastfood, color: AppColors.primary),
                ),
                validator: (value) => value!.isEmpty ? AppStrings.enterFoodName : null,
              ),

              TextFormField(
                style:  Theme.of(context).textTheme.bodyMedium,
                controller: caloriesController,
                decoration: inputDecoration.copyWith(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: AppStrings.calories,
                  prefixIcon: const Icon(Icons.local_fire_department, color: AppColors.primary),
                ),
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                style:  Theme.of(context).textTheme.bodyMedium,
                controller: proteinController,
                decoration: inputDecoration.copyWith(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: AppStrings.proteinG,
                  prefixIcon: const Icon(Icons.fitness_center, color: AppColors.primary),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                style:  Theme.of(context).textTheme.bodyMedium,
                controller: carbsController,
                decoration: inputDecoration.copyWith(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: AppStrings.carbsG,
                  prefixIcon: const Icon(Icons.grain, color: AppColors.primary),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                style:  Theme.of(context).textTheme.bodyMedium,
                controller: fatsController,
                decoration: inputDecoration.copyWith(
                  labelStyle: Theme.of(context).textTheme.bodyMedium,
                  labelText: AppStrings.fatsG,
                  prefixIcon: const Icon(Icons.opacity, color: AppColors.primary),
                ),
                keyboardType: TextInputType.number,
              ),
              Padding(padding: EdgeInsets.only(top: 8.h),
                child: buildAppButton(
                  context, label: "Add Food", icon: Icons.add, height: 40, radius: 10, isLoading: _isLoading,
                  callback: () async {
                  _toggleLoading(true);
                  if (_formKey.currentState!.validate()) {
                    final name = nameController.text;
                    final protein = double.tryParse(proteinController.text) ?? 0;
                    final carbs = double.tryParse(carbsController.text) ?? 0;
                    final fats = double.tryParse(fatsController.text) ?? 0;
                    final calories = double.tryParse(caloriesController.text) ?? 0;
                    final date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                    final entry = FoodEntry(
                        id: Uuid().v4(),
                        foodName: name,
                        protein: protein,
                        carbs: carbs,
                        fats: fats,
                        calories: calories,
                        foodId: Uuid().v4(),
                        mealType: '',
                        userId: FireBaseService().getFirebaseUserId(),
                        date: Timestamp.fromDate(date),
                        time: Timestamp.now(),
                        isDeleted: false
                    );

                    await ref.read(foodProvider.notifier).addFood(entry);

                    context.pop();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
