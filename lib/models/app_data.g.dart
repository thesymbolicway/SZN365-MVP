// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
  id: json['id'] as String?,
  weight: json['weight'] as String?,
  height: json['height'] as String?,
  age: json['age'] as String?,
  gender: json['gender'] as String?,
  activityLevel: json['activityLevel'] as String?,
  goal: json['goal'] as String?,
);

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'weight': instance.weight,
  'height': instance.height,
  'age': instance.age,
  'gender': instance.gender,
  'activityLevel': instance.activityLevel,
  'goal': instance.goal,
};
