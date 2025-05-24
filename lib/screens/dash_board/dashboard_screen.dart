import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:szn365/screens/dash_board/progress_bar.dart';
import 'package:szn365/screens/dash_board/widgets.dart';
import 'package:szn365/utils/colors.dart';
import '../../models/food_entry.dart';
import '../../models/macro_data.dart';
import '../../providers/dash_provider.dart';
import '../../utils/app_strings.dart';
import '../../widgets/gradient_background.dart';
import '../food_selection/food_selection_screen.dart';


class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meals = ref.watch(dashProvider);

   return FutureBuilder<MacroData?>(
      future: ref.read(dashProvider.notifier).getUserMacroGoal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && meals !=  AsyncLoading()) {
          return Center(child: CupertinoActivityIndicator(
              color: AppColors.primary));
        } else if (snapshot.hasError) {
          return Text('Error loading goals');
        } else {
          final macroData = snapshot.data;
          return GradientBackground(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title:  Text(AppStrings.dashboard,style: Theme.of(context).appBarTheme.titleTextStyle,),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Goals: ${macroData?.goal??''}",
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                Spacer()
                                ,
                                IconButton(onPressed: () {
                                  Navigator.pushNamed(context, '/boarding');
                                },
                                  icon: Icon(Icons.edit),
                                  iconSize: 18,
                                  color: AppColors.white,)
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    const SizedBox(height: 20),

                    meals.when(data: (meals) =>  Column(
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
                                SizedBox(width: 12),
                                Expanded(
                                  child: buildProgressBar(
                                    context,
                                    AppStrings.protein,
                                    ref.read(dashProvider.notifier).currentProtein / macroData.proteinGrams,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: buildProgressBar(
                                    context,
                                    AppStrings.carbs,
                                    ref.read(dashProvider.notifier).currentCarbs / macroData.carbGrams,
                                  ),
                                ),
                                SizedBox(width: 12),
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
                        const SizedBox(height: 20),
                        Column(
                          children: [
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
                            })
                            ,
                            const SizedBox(height: 10),
                            buildPlaceholderCard(
                              AppStrings.mealPlan,
                              context,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ],
                    ),
                      error: (e, st) => Text('Error: $e'),
                      loading: () => Center(child: CupertinoActivityIndicator(
                          color: AppColors.primary)),
                    )

                  ],
                ),
              ),
            ),
          );
        }
      },
    );

  }
}
