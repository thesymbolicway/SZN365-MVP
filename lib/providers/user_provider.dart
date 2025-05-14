import 'package:fluttertoast/fluttertoast.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:szn365/utils/colors.dart';
import '../models/app_data.dart';
import '../services/firestore_service.dart';
import '../services/macro_calculator.dart';

part 'user_provider.g.dart';

@Riverpod(keepAlive: true)
class User extends _$User {
  final FireBaseService _fireBaseService = FireBaseService();

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

    await Future.delayed(Duration(microseconds: 10));

    Fluttertoast.showToast(
      msg: "Your TDEE is ${tdee.toStringAsFixed(0)} kcal/day",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      fontSize: 16.0,
    );
  }

  void updateUserLocally(AppUser updatedUser) {
    state = AsyncData(updatedUser);
  }

}
