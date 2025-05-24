import 'package:json_annotation/json_annotation.dart';
part 'macro_data.g.dart';

@JsonSerializable()
class MacroData {
  final String id;
  final String userId;
  final String? goal;
  final DateTime date;
  final double tdee;
  final double proteinGrams;
  final double fatGrams;
  final double carbGrams;

  MacroData({
    required this.goal,
    required this.id,
    required this.userId,
    required this.date,
    required this.tdee,
    required this.proteinGrams,
    required this.fatGrams,
    required this.carbGrams,
  });

  factory MacroData.fromJson(Map<String, dynamic> json) =>
      _$MacroDataFromJson(json);

  Map<String, dynamic> toJson() => _$MacroDataToJson(this);

}
