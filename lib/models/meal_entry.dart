
import '../models/food_entry.dart';

class MealEntry {
  final String title;
  List<FoodEntry> items;

  MealEntry({required this.title, this.items = const []});
}