import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/activity.dart';
 // Ensure that UserData is imported

class UserProvider extends ChangeNotifier {
  UserData _userData = UserData();
  UserData get userData => _userData;

  // Load user data from Hive
  Future<void> loadUserData() async {
    var box = await Hive.openBox<UserData>('user_data');
    _userData = box.get('user_data') ?? UserData();

    // Ensure the activities list is mutable (copy it if necessary)
    _userData.activities = List.from(_userData.activities);  // This will clone the list if it's unmodifiable

    notifyListeners();
  }

  // Save user data to Hive
  Future<void> saveUserData() async {
    var box = await Hive.openBox<UserData>('user_data');
    box.put('user_data', _userData);
  }

  // Add an activity to the user data
  void addActivity(String activityName) {
    // Activities list should be mutable, so you can add to it
    _userData.activities.add(Activity(activityName, DateTime.now()));
    _userData.points += 10;  // Add points for each activity

    // Check if more than 3 activities are logged today, and award bonus points
    if (_userData.activities.where((activity) => activity.activityDate.day == DateTime.now().day).length > 3) {
      _userData.points += 20;
    }

    // Notify listeners after making changes and save data to Hive
    notifyListeners();
    saveUserData();
  }

  // Predict the next milestone based on current points
  String predictNextMilestone() {
    int currentPoints = _userData.points;
    int nextMilestone = ((currentPoints ~/ 50) + 1) * 50;  // Round up to the next 50 points
    return "Next Milestone: $nextMilestone points";
  }
}
