import 'package:equatable/equatable.dart';
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
  DashStates build() {
    Future.microtask(() {
      getUserMacroGoal();
      getMealsList();
    });
    return const DashStates(isLoading: true);
  }

  Future<void> getMealsList() async {
    try {
      final logs = await service.getUserFoodLogForDate(DateTime.now());
      final mealTitles = ['Breakfast', 'Lunch', 'Snacks / Other', 'Dinner'];

      final Map<String, List<FoodEntry>> grouped = {
        for (final title in mealTitles) title: [],
      };
      for (final meal in logs) {
        grouped[meal.title] = meal.items;
      }
      List<MealEntry> list = mealTitles.map((title) => MealEntry(title: title, items: grouped[title]!)).toList();

      state = state.copyWith(mealsList: list, isLoading: false);
      calculateNutritionSum();
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error as needed
    }
  }

  Future<void> loadUserMacroGoal() async {
    try {
      final userId = service.getFirebaseUserId();
      if (userId == null || userId.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final macroGoal = await service.getUserGoal(userId);
      state = state.copyWith(macroData: macroGoal, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error as needed
    }
  }

  Future<void> getUserMacroGoal() async {
    try {
      final userId = service.getFirebaseUserId();
      if (userId == null || userId.isEmpty) {
        state = state.copyWith(isLoading: false);
        return;
      }

      MacroData? data = await service.getUserGoal(userId);
      state = state.copyWith(macroData: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      // Handle error as needed
    }
  }

  Future<void> addFood(String mealType, FoodEntry item) async {
    toggleLoading(true, "Adding");

    final date = DateTime.now();
    final itemWithId = item.copyWith(id: const Uuid().v4());

    await service.addUserFoodLog(itemWithId, mealType, date);

    final currentMeals = state.mealsList;
    final updatedMeals = [
      for (final meal in currentMeals)
        if (meal.title == mealType)
          MealEntry(title: meal.title, items: [...meal.items, itemWithId])
        else
          meal
    ];
    state = state.copyWith(mealsList: updatedMeals, isLoading: false);
    calculateNutritionSum();
  }

  Future<void> removeFood(String mealType, FoodEntry item) async {
    toggleLoading(true, "Removing");

    final date = DateTime.now();
    await service.removeUserFoodLog(item, mealType, date);

    final currentMeals = state.mealsList;
    final updatedMeals = [
      for (final meal in currentMeals)
        if (meal.title == mealType)
          MealEntry(
            title: meal.title,
            items: meal.items.where((i) => i.id != item.id).toList(),
          )
        else meal
    ];
    state = state.copyWith(mealsList: updatedMeals, isLoading: false);
    calculateNutritionSum();
  }

  void calculateNutritionSum() {
    double calories = _sum((item) => item.calories);
    double protein = _sum((item) => item.protein);
    double carbs = _sum((item) => item.carbs);
    double fats = _sum((item) => item.fats);
    state = state.copyWith(nutritionSummary: NutritionSummary(
        calories: calories, protein: protein, carbs: carbs, fats: fats));
  }

  double _sum(double Function(FoodEntry) extractor) {
    final meals = state.mealsList;
    return meals.expand((meal) => meal.items).fold(0.0, (sum, item) => sum + extractor(item));
  }

  void toggleLoading(bool flag, String loadingText) {
    state = state.copyWith(isLoading: flag, loadingText: loadingText);
  }
}

/// Dashboard States
class DashStates extends Equatable {
  final bool isLoading;
  final String loadingText;
  final List<MealEntry> mealsList;
  final MacroData? macroData;
  final NutritionSummary nutritionSummary;

  const DashStates({
    this.isLoading = false,
    this.loadingText = "Loading",
    this.mealsList = const [],
    this.macroData,
    this.nutritionSummary = const NutritionSummary(),
  });

  DashStates copyWith({
    bool? isLoading,
    String? loadingText,
    List<MealEntry>? mealsList,
    MacroData? macroData,
    NutritionSummary? nutritionSummary,
  }) {
    return DashStates(
      isLoading: isLoading ?? this.isLoading,
      loadingText: loadingText ?? this.loadingText,
      mealsList: mealsList ?? this.mealsList,
      macroData: macroData ?? this.macroData,
      nutritionSummary: nutritionSummary ?? this.nutritionSummary,
    );
  }

  @override
  List<Object?> get props => [isLoading, loadingText, mealsList, macroData, nutritionSummary];
}

class NutritionSummary {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;

  const NutritionSummary({
    this.calories = 0,
    this.protein = 0,
    this.carbs = 0,
    this.fats = 0,
  });
}

