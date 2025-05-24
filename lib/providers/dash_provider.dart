import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../models/macro_data.dart';
import '../models/meal_entry.dart';
import '../models/food_entry.dart';
import '../services/firestore_service.dart';

part 'dash_provider.g.dart';

@riverpod
class Dash extends _$Dash {
  final FireBaseService service = FireBaseService();

  @override
  Future<List<MealEntry>> build() async {

    final logs = await service.getUserFoodLogForDate(DateTime.now());
    final mealTitles = ['Breakfast', 'Lunch', 'Snacks / Other', 'Dinner'];

    final Map<String, List<FoodEntry>> grouped = {
      for (final title in mealTitles) title: [],
    };

    for (final meal in logs) {
      grouped[meal.title] = meal.items;
    }

    return mealTitles
        .map((title) => MealEntry(title: title, items: grouped[title]!))
        .toList();
  }

  Future<MacroData?> getUserMacroGoal() async {
    final userId = service.getFirebaseUserId();
    if (userId == null || userId.isEmpty) return null;

    return await service.getUserGoal(userId);
  }


  void addFood(String mealType, FoodEntry item) {
    final date = DateTime.now();
    item.copyWith(id: Uuid().v4());
    service.addUserFoodLog(item, mealType,date);
    final currentState = state.valueOrNull ?? [];
    state = AsyncData([
      for (final m in currentState)
        if (m.title == mealType)
          MealEntry(title: m.title, items: [...m.items, item])
        else
          m
    ]);
  }

  void removeFood(String mealType, FoodEntry item) async {
    state = const AsyncLoading();

    final date = DateTime.now();
    await service.removeUserFoodLog(item, mealType,date);
    final currentState = state.valueOrNull ?? [];
    state = AsyncData([
      for (final m in currentState)
        if (m.title == mealType)
          MealEntry(
              title: m.title,
              items: m.items.where((i) => i != item).toList())
        else
          m
    ]);
  }

  double get currentCalories => _sum((item) => item.calories);
  double get currentProtein => _sum((item) => item.protein);
  double get currentCarbs => _sum((item) => item.carbs);
  double get currentFats => _sum((item) => item.fats);

  double _sum(double Function(FoodEntry) extractor) {
    final meals = state.valueOrNull ?? [];
    return meals.expand((meal) => meal.items).fold(0.0, (sum, item) => sum + extractor(item));
  }

}
