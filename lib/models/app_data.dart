import 'package:json_annotation/json_annotation.dart';

part 'app_data.g.dart';

@JsonSerializable()
class AppUser {
  final String? id;
  final String? weight;
  final String? height;
  final String? age;
  final String? gender;
  final String? activityLevel;
  final String? goal;

  AppUser({
    required this.id,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.activityLevel,
    this.goal,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser copyWith({
    String? weight,
    String? height,
    String? age,
    String? gender,
    String? activityLevel,
    String? goal,
  }) {
    return AppUser(
      id: id,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
    );
  }
}
