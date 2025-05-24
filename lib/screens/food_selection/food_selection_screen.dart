import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/food_provider.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../widgets/gradient_background.dart';
import 'add_food_bottom_sheet.dart';


class FoodSelectionScreen extends ConsumerWidget {
  final String mealType;

  const FoodSelectionScreen({super.key, required this.mealType});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final theme = Theme.of(context);
    final dummyItems =  ref.watch(foodProvider);
    final foodNotifier = ref.read(foodProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Select Food for $mealType',style: Theme.of(context).appBarTheme.titleTextStyle,),
          backgroundColor: theme.appBarTheme.backgroundColor ?? AppColors.primary,
          foregroundColor: theme.appBarTheme.foregroundColor ?? AppColors.white,
        ),
        body: dummyItems.when(data: (dummyItems) =>Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                style: Theme.of(context).textTheme.bodyMedium, // Text color
                cursorColor: Colors.white, // Cursor color
                decoration: InputDecoration(
                  hintText: AppStrings.searchFood,
                  hintStyle: const TextStyle(color: Colors.white70), // Hint color
                  prefixIcon: const Icon(Icons.search, color: Colors.white), // Icon color
                  filled: true,
                  fillColor: Colors.transparent, // or any background like Colors.black
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                onChanged: (value) {
                  foodNotifier.search(value);
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  itemCount: dummyItems.length,
                  itemBuilder: (context, index) {
                    final item = dummyItems[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        leading: Icon(Icons.fastfood, color:  AppColors.primary),
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
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${item.calories} kcal',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
          error: (e, st) => Text('Error: $e'),
          loading: () => Center(child: CupertinoActivityIndicator(radius: 10,
              color: AppColors.primary)),
        )
          ,
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const AddFoodBottomSheet(),
            );
          },
          child: const Icon(Icons.add, color: AppColors.white),
          tooltip: AppStrings.addFoodEntry,
        ),
      ),
    );
  }
}
