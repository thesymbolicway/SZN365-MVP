import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:szn365/utils/colors.dart';
import 'package:uuid/uuid.dart';
import '../models/app_data.dart';
import '../models/macro_data.dart';
import '../services/firestore_service.dart';
import '../services/macro_calculator.dart';
import '../utils/app_strings.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  final FireBaseService _fireBaseService = FireBaseService();
  final DateTime today = DateTime.now();
  final uuid = Uuid().v4();

  @override
  FutureOr<AppUser?> build() async {
    return null;
  }

  Future<void> loadUser(String userId) async {
    state = const AsyncLoading();
    try {
      final user = await _fireBaseService.getUser(userId);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> setUser(AppUser user) async {
    try {
      await _fireBaseService.setUser(user);
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


  Future<void> getTDECalculation(AppUser user) async {

    var tdee = MacroCalculator.calculateTDEE(
      weightLb: double.parse(user.weight.toString()),
      heightCm: double.parse(user.height.toString()),
      age: int.parse(user.age.toString()),
      gender: user.gender??'',
      activityLevel: double.parse(user.activityLevel.toString()),
    );

    late double proteinPerKg;

    switch (user.goal?.toLowerCase()) {
      case AppStrings.goalLose:
        tdee -= 500;
        proteinPerKg = 2.4;
        break;
      case AppStrings.goalGain:
        tdee += 500;
        proteinPerKg = 2.2;
        break;
      case AppStrings.goalMaintain:
      default:
        proteinPerKg = 2.0;
    }

    final proteinGrams = double.parse(user.weight.toString()) * proteinPerKg;
    final proteinCalories = proteinGrams * 4;

    final fatCalories = tdee * 0.25;
    final fatGrams = fatCalories / 9;

    final remainingCalories = tdee - (proteinCalories + fatCalories);
    final carbGrams = remainingCalories / 4;

    var userGoal =  MacroData(
      goal: user.goal,
      id: uuid,
      userId: _fireBaseService.getFirebaseUserId()??'',
      date: today,
      tdee: tdee.roundToDouble(),
      proteinGrams: proteinGrams.roundToDouble(),
      fatGrams: fatGrams.roundToDouble(),
      carbGrams: carbGrams.roundToDouble(),
    );

    await _fireBaseService.setUserGoal(userGoal);

  }

  void updateUserLocally(AppUser updatedUser) {
    state = AsyncData(updatedUser);
  }

}
