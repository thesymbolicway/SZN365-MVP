// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'macro_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MacroData _$MacroDataFromJson(Map<String, dynamic> json) => MacroData(
  goal: json['goal'] as String?,
  id: json['id'] as String,
  userId: json['userId'] as String,
  date: DateTime.parse(json['date'] as String),
  tdee: (json['tdee'] as num).toDouble(),
  proteinGrams: (json['proteinGrams'] as num).toDouble(),
  fatGrams: (json['fatGrams'] as num).toDouble(),
  carbGrams: (json['carbGrams'] as num).toDouble(),
);

Map<String, dynamic> _$MacroDataToJson(MacroData instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'goal': instance.goal,
  'date': instance.date.toIso8601String(),
  'tdee': instance.tdee,
  'proteinGrams': instance.proteinGrams,
  'fatGrams': instance.fatGrams,
  'carbGrams': instance.carbGrams,
};
