import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:szn365/utils/raw_timestamp_converter.dart';

 part 'food_entry.g.dart';

@JsonSerializable()
class FoodEntry {
  final String? id;
  final String foodId;
  final String foodName;
  final double protein;
  final double carbs;
  final double fats;
  final double calories;
  final String mealType;
  final String? userId;
  @TimestampConverter()
  final Timestamp? date;
  @TimestampConverter()
  final Timestamp? time;
  final bool? isDeleted;

  FoodEntry({
    required this.userId,
    required this.date,
    required this.time,
    this.isDeleted = false,
    required this.id,
    required this.foodId,
    required this.foodName,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.calories,
    required this.mealType,
  });

  FoodEntry copyWith({
      String? id,
     String? foodId,
     String? foodName,
     String? details,
     double? protein,
     double? carbs,
     double? fats,
     double? calories,
     String? mealType,
    final String? userId,
    final Timestamp? date,
    final Timestamp? time,
    final bool? isDeleted,
  }) {
     return FoodEntry(
        id: id?? this.id,
       foodId: foodId?? this.foodId,
       foodName: foodName?? this.foodName,
       protein: protein?? this.protein,
       carbs: carbs?? this.carbs,
       fats: fats?? this.fats,
       calories: calories?? this.calories,
       mealType: mealType?? this.mealType,
       userId: userId?? this.userId,
       date: date?? this.date,
       time: time?? this.time,
       isDeleted: isDeleted?? this.isDeleted
     );
  }

  factory FoodEntry.fromJson(Map<String, dynamic> json) => _$FoodEntryFromJson(json);

  Map<String, dynamic> toJson() => _$FoodEntryToJson(this);

}



