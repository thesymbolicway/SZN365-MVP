// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodEntry _$FoodEntryFromJson(Map<String, dynamic> json) => FoodEntry(
  userId: json['userId'] as String?,
  date: const TimestampConverter().fromJson(json['date']),
  time: const TimestampConverter().fromJson(json['time']),
  isDeleted: json['isDeleted'] as bool? ?? false,
  id: json['id'] as String?,
  foodId: json['foodId'] as String,
  foodName: json['foodName'] as String,
  protein: (json['protein'] as num).toDouble(),
  carbs: (json['carbs'] as num).toDouble(),
  fats: (json['fats'] as num).toDouble(),
  calories: (json['calories'] as num).toDouble(),
  mealType: json['mealType'] as String,
);

Map<String, dynamic> _$FoodEntryToJson(FoodEntry instance) => <String, dynamic>{
  'id': instance.id,
  'foodId': instance.foodId,
  'foodName': instance.foodName,
  'protein': instance.protein,
  'carbs': instance.carbs,
  'fats': instance.fats,
  'calories': instance.calories,
  'mealType': instance.mealType,
  'userId': instance.userId,
  'date': const TimestampConverter().toJson(instance.date),
  'time': const TimestampConverter().toJson(instance.time),
  'isDeleted': instance.isDeleted,
};
