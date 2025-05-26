
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:szn365/services/firestore_service.dart';
import 'package:uuid/uuid.dart';
import '../models/food_entry.dart';

part 'food_provider.g.dart';

@riverpod
class Food extends _$Food {
  final FireBaseService _service = FireBaseService();

  @override
  Future<List<FoodEntry>> build() async {
    final foods = await _service.getAllFoodEntries();
    return foods;
  }

  Future<void> addFood(FoodEntry food) async {
    await _service.addFoodEntry(food);
    state = AsyncData([...state.value ?? [], food]);
  }

  Future<void> addGlobalFoodList(FoodEntry food) async {
    await _service.addFoodEntry(food);
    state = AsyncData([...state.value ?? [], food]);
  }

  Future<void> removeFood(String id) async {
  //  await _service.deleteFoodEntry(id);
    final updated = (state.value ?? []).where((item) => item.id != id).toList();
    state = AsyncData(updated);
  }

  void search(String query) {
    final list = state.value ?? [];
    if (query.trim().isEmpty) {
      ref.invalidateSelf(); // Re-fetch all
    } else {
      final filtered = list.where((food) =>
          food.foodName.toLowerCase().contains(query.toLowerCase())).toList();
      state = AsyncData(filtered);
    }
  }

  void generateAndUploadFoods() async {

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final uuid = Uuid();

    final List<String> foodNames = [
      'Jumbo Peanuts Spicy Chilli', 'Grilled Chicken Breast', 'Brown Rice',
      'Greek Yogurt', 'Banana', 'Protein Shake', 'Avocado Toast',
      'Scrambled Eggs', 'Oatmeal with Berries', 'Quinoa Salad', 'Almond Butter',
      'Tofu Stir Fry', 'Steamed Broccoli', 'Sweet Potato', 'Tuna Sandwich',
      'Whole Grain Pasta', 'Cottage Cheese', 'Beef Jerky', 'Trail Mix',
      'Mango Smoothie', 'Turkey Wrap', 'Boiled Eggs', 'Apple Slices',
      'Vegetable Soup', 'Peanut Butter Sandwich', 'Mixed Nuts', 'Hummus & Pita',
      'Green Salad', 'Fruit Bowl', 'Energy Bar', 'Rice Cakes', 'Lentil Curry',
      'Grilled Salmon', 'Spinach Omelette', 'Milk', 'Orange Juice',
      'Baked Beans', 'Roasted Chickpeas', 'Zucchini Noodles',
      'Cheese Cubes', 'Granola Bar', 'Veggie Wrap', 'Pancakes',
      'Blueberry Muffin', 'Chia Pudding', 'Pumpkin Seeds',
      'Bulgur Wheat Salad', 'Mashed Potatoes', 'Chickpea Salad', 'Egg Salad'
    ];

    final List<String> mealTypes = ['breakfast', 'lunch', 'dinner', 'snack'];

    final foodList = List.generate(20, (index) {
      return FoodEntry(
        id: uuid.v4(),
        foodId: uuid.v4(),
        foodName: foodNames[index % foodNames.length],
        protein: double.parse((5 + (25 * (index % 10) / 10)).toStringAsFixed(1)),
        carbs: double.parse((10 + (40 * (index % 7) / 7)).toStringAsFixed(1)),
        fats: double.parse((5 + (25 * (index % 5) / 5)).toStringAsFixed(1)),
        calories: double.parse((100 + (600 * (index % 6) / 6)).toStringAsFixed(1)),
        mealType: mealTypes[index % mealTypes.length],
        userId: 'global',
        date: Timestamp.fromDate(today),
        time: Timestamp.now(),
        isDeleted: false,
      );
    });

    await uploadGlobalFoodList(foodList);
  }

  Future<void> uploadGlobalFoodList(List<FoodEntry> foodList) async {
    for (final food in foodList) {
      await addGlobalFoodList(food);
    }
  }

}

