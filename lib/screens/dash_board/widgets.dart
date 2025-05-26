import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/meal_entry.dart';
import '../../providers/dash_provider.dart';
import '../../utils/colors.dart';

Widget buildFoodLogCard(
    BuildContext context,
    WidgetRef ref,
    List<MealEntry> meals,
    Future<void> Function(String mealType) onAddFood,
    ) {
  final theme = Theme.of(context);

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
    margin: EdgeInsets.symmetric(horizontal: 4.w),
    child: Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: meals.map((meal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Header
              Padding(
                padding: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal.title,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_outline, color: Colors.white, size: 25.w),
                          onPressed: () => onAddFood(meal.title),
                          tooltip: 'Add food to ${meal.title}',
                          visualDensity: VisualDensity.compact,
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // Food Items
              ...meal.items.map((item) {
                return Dismissible(
                  key: ValueKey(item.id ?? item.hashCode),
                  direction: DismissDirection.endToStart,
                  dismissThresholds: const {
                    DismissDirection.endToStart: 0.3, // Require 30% swipe to dismiss
                  },
                  confirmDismiss: (direction) async {
                    return true;
                  },
                  onDismissed: (direction) {
                    Future.microtask(() {
                      ref.read(dashProvider.notifier).removeFood(meal.title, item);
                    });
                  },
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white, size: 20),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 1,
                    shadowColor: AppColors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                      dense: true,
                      title: Text(
                        item.foodName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'P:${item.protein} | C:${item.carbs} | F:${item.fats}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      trailing: Text(
                        '${item.calories} kcal',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Divider Between Meals
              if (meal != meals.last) const Divider(height: 20, thickness: 0.8),
            ],
          );
        }).toList(),
      ),
    ),
  );
}

Widget buildGoalColumn(BuildContext context,String title, String value, IconData icon) {
  return Expanded(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 35.w, color: AppColors.primary),
        SizedBox(height: 6.h),
        Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp)),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 14.sp)),
      ],
    ),
  );
}

Widget buildPlaceholderCard(String title,BuildContext context,{double? width}) {
  return GestureDetector(
    onTap: () {
      if (title == 'Food Log') {
        Navigator.pushNamed(context, '/food-log');
      } else if (title == 'Meal Plan') {
      //  Navigator.pushNamed(context, '/meal-plan');
      }
    },
    child: Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: width,
        height: 80,
        alignment: Alignment.center,
        child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge
        ),
      ),
    ),
  );
}