import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: meals.map((meal) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Header
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                          icon: const Icon(Icons.add_circle_outline, color: Colors.white, size: 20),
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
                  key: ValueKey(item.hashCode),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    ref.read(dashProvider.notifier).removeFood(meal.title, item);
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
                            style: Theme.of(context).textTheme.bodySmall),
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
              }).toList(),

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
  return Column(
    children: [
      Icon(icon, size: 30, color: AppColors.primary),
      const SizedBox(height: 6),
      Text(title, style: Theme.of(context).textTheme.bodyMedium,),
      Text(value, style: Theme.of(context).textTheme.bodyLarge,),
    ],
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