import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:szn365/consts/constant.dart';
import '../models/app_data.dart';
import '../models/food_entry.dart';
import '../models/macro_data.dart';
import '../models/meal_entry.dart';

class FireBaseService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? getFirebaseUserId() {
    return _firebaseAuth.currentUser?.uid;
  }

  Future<void> setUser(AppUser user) async {
    await _db.collection(Constant.usersTable).doc(user.id).set(user.toJson());
  }

  Future<void> setUserGoal(MacroData macroData) async {
    await _db.collection(Constant.goalsTable).doc(getFirebaseUserId()).set(macroData.toJson());
  }

  Future<MacroData?> getUserGoal(String userId) async {
    final doc = await _db.collection(Constant.goalsTable).doc(userId).get();

    if (doc.exists && doc.data() != null) {
      return MacroData.fromJson(doc.data()!);
    }
    return null;
  }

  Future<AppUser?> getUser(String userId) async {
    final doc = await _db.collection(Constant.usersTable).doc(userId).get();

    if (doc.exists && doc.data() != null) {
      return AppUser.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> removeUserFoodLog(FoodEntry item, String mealType,DateTime now) async {
    final date = DateTime(now.year, now.month, now.day);
    final userId = getFirebaseUserId();
    bool isFoundData = false;

    if (userId == null) return;

    final snapshot = await _db
        .collection(Constant.foodLogsTable)
        .where('userId', isEqualTo: userId)
        .where('foodId', isEqualTo: item.foodId)
        .where('mealType', isEqualTo: mealType)
        .where('id', isEqualTo: item.id)
        .get();

    isFoundData = snapshot.size > 0;

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
    if(isFoundData){
      await updateDailyGoalStatus(date);
    }
  }

  Future<void> addFoodEntry(FoodEntry entry) async {
    await _db.collection(Constant.foodsTable).doc(entry.id).set(entry.toJson());
  }

  Future<List<FoodEntry>> getAllFoodEntries() async {
    final userId = getFirebaseUserId();

    final userQuery = _db
        .collection(Constant.foodsTable)
        .where('userId', isEqualTo: userId)
        .get();

    final globalUserQuery = _db
        .collection(Constant.foodsTable)
        .where('userId', isEqualTo: 'global')
        .get();

    final results = await Future.wait([userQuery, globalUserQuery]);

    final allDocs = [
      ...results[0].docs,
      ...results[1].docs,
    ];

    allDocs.sort((a, b) {
      final aTime = a.data()['time'] as Timestamp?;
      final bTime = b.data()['time'] as Timestamp?;
      return bTime?.compareTo(aTime ?? Timestamp(0, 0)) ?? 0;
    });

    return allDocs.map((doc) => FoodEntry.fromJson(doc.data())).toList();
  }

  Future<void> addUserFoodLog(FoodEntry item, String mealType,DateTime now) async {
    final userId = getFirebaseUserId();
    if (userId == null) return;

    final date = DateTime(now.year, now.month, now.day); // only date
    var foodLog =  FoodEntry(
        userId: userId,
        foodId: item.foodId,
        foodName: item.foodName,
        mealType: mealType,
        protein: item.protein,
        carbs: item.carbs,
        fats: item.fats,
        calories: item.calories,
        date: Timestamp.fromDate(date),
        time: Timestamp.now(),
        isDeleted: false,
        id: item.id,
      );

    await _db.collection(Constant.foodLogsTable).add(foodLog.toJson());

    await updateDailyGoalStatus(date);
  }

  Future<void> updateDailyGoalStatus(DateTime date) async {
    final userId = getFirebaseUserId();
    if (userId == null) return;
    await Future.delayed(Duration(seconds: 1));
    final snapshot = await _db
        .collection(Constant.foodLogsTable)
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: Timestamp.fromDate(date))
        .where('isDeleted', isEqualTo: false)
        .get();

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      totalCalories += (data['calories'] ?? 0).toDouble();
      totalProtein += (data['protein'] ?? 0).toDouble();
      totalCarbs += (data['carbs'] ?? 0).toDouble();
      totalFats += (data['fats'] ?? 0).toDouble();
    }

    final goal = await getUserGoal(userId);
    bool goalAchieved = false;

    if (goal != null) {
      final p = totalProtein >= goal.proteinGrams;
      final c = totalCarbs >= goal.carbGrams;
      final f = totalFats >= goal.fatGrams;
      goalAchieved = p && c && f;
    }

    await _db
        .collection(Constant.dailyGoalsTable)
        .doc('$userId-${date.toIso8601String().substring(0, 10)}') // unique per user & date
        .set({
      'id': '$userId-${date.toIso8601String().substring(0, 10)}',
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'goalAchieved': goalAchieved,
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalCarbs': totalCarbs,
      'totalFats': totalFats,
    });
  }

  Future<List<MealEntry>> getUserFoodLogForDate(DateTime date) async {
    final userId = getFirebaseUserId();
    if (userId == null) return [];

    final targetDate = DateTime(date.year, date.month, date.day);

    final snapshot = await _db
        .collection(Constant.foodLogsTable)
        .where('userId', isEqualTo: userId)
        .where('date', isEqualTo: Timestamp.fromDate(targetDate))
        .where('isDeleted', isEqualTo: false)
        .get();

    final allItems = snapshot.docs.map((doc) => FoodEntry.fromJson(doc.data())).toList();

    // Prepare MealEntry list
    final mealTitles = ['Breakfast', 'Lunch', 'Snacks / Other', 'Dinner'];
    final Map<String, List<FoodEntry>> grouped = {
      for (final title in mealTitles) title: [],
    };

    for (final entry in allItems) {
      final meal = entry.mealType ?? 'Snacks / Other';
      if (grouped.containsKey(meal)) {
        grouped[meal]!.add(entry);
      } else {
        grouped['Snacks / Other']!.add(entry);
      }
    }

    return mealTitles
        .map((title) => MealEntry(title: title, items: grouped[title]!))
        .toList();
  }

}
