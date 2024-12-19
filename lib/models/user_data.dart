// TODO Implement this library.
import 'package:hive/hive.dart';

import 'activity.dart';
  // Ensure Activity model is imported



@HiveType(typeId: 1)
class UserData {
  @HiveField(0)
  int points = 0;

  @HiveField(1)
  List<Activity> activities = [];  // A mutable list of activities

  UserData();
}
