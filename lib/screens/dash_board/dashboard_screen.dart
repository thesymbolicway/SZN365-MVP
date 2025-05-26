import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:szn365/screens/dash_board/progress_bar.dart';
import 'package:szn365/screens/dash_board/widgets.dart';
import 'package:szn365/utils/colors.dart';
import 'package:szn365/widgets/app_loader.dart';
import '../../models/food_entry.dart';
import '../../models/meal_entry.dart';
import '../../providers/dash_provider.dart';
import '../../utils/app_strings.dart';
import '../../widgets/gradient_background.dart';
import '../food_selection/food_selection_screen.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    return Consumer(
        builder: (_, ref, _) {
          final macroData = ref.watch(dashProvider.select((s) => s.macroData));
          return GradientBackground(
            child: Stack(children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title:  Text(AppStrings.dashboard,style: Theme.of(context).appBarTheme.titleTextStyle,),
                  centerTitle: true,
                  //scrolledUnderElevation: 0,
                ),
                body: SingleChildScrollView(
                  //physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: Column(
                    spacing: 15.h,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Goals: ${macroData?.goal??''}",
                                    style: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  Spacer(),
                                  IconButton(onPressed: () {
                                    Navigator.pushNamed(context, '/boarding');
                                  },
                                    icon: Icon(Icons.edit),
                                    iconSize: 20.w,
                                    color: AppColors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  buildGoalColumn(context,
                                    AppStrings.calories,
                                    "${macroData?.tdee.toInt()} kcal",
                                    Icons.local_fire_department,
                                  ),
                                  buildGoalColumn(context,
                                    AppStrings.protein,
                                    "${macroData?.proteinGrams.toInt()} g",
                                    Icons.restaurant_menu,
                                  ),
                                  buildGoalColumn(context,
                                    AppStrings.carbs,
                                    "${macroData?.carbGrams.toInt()} g",
                                    Icons.bubble_chart,
                                  ),
                                  buildGoalColumn(context,
                                    AppStrings.fats,
                                    "${macroData?.fatGrams.toInt()} g",
                                    Icons.opacity,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Consumer(builder: (context, ref, child) {
                        List<MealEntry> meals = ref.watch(dashProvider.select((s) => s.mealsList));
                        return meals.isNotEmpty ? Column(
                          spacing: 15.h,
                          children: [
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: buildProgressBar(
                                        context,
                                        AppStrings.calories,
                                        ref.read(dashProvider.notifier).currentCalories / macroData!.tdee,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: buildProgressBar(
                                        context,
                                        AppStrings.protein,
                                        ref.read(dashProvider.notifier).currentProtein / macroData.proteinGrams,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: buildProgressBar(
                                        context,
                                        AppStrings.carbs,
                                        ref.read(dashProvider.notifier).currentCarbs / macroData.carbGrams,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: buildProgressBar(
                                        context,
                                        AppStrings.fats,
                                        ref.read(dashProvider.notifier).currentFats / macroData.fatGrams,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ),

                            buildFoodLogCard(context, ref, meals, (mealType) async {
                              final selected = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => FoodSelectionScreen(mealType: mealType),
                                ),
                              );
                              if (selected is FoodEntry) {
                                ref.read(dashProvider.notifier).addFood(mealType, selected);
                              }
                            }),

                            buildPlaceholderCard(
                              AppStrings.mealPlan,
                              context,
                              width: double.infinity,
                            ),

                            SizedBox(height: 20),
                          ],
                        ) : SizedBox(height: bottomPadding + 15.h);
                      }),
                    ],
                  ),
                ),
              ),

              Consumer(builder: (context, ref, child) {
                bool isLoading = ref.watch(dashProvider.select((s) => s.isLoading));
                String text = ref.read(dashProvider.select((s) => s.loadingText));
                return isLoading ? AppLoader(text: text) : SizedBox();
              })
            ]),
          );
        }
    );
  }
}
