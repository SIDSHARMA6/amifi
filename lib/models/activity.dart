import 'package:hive/hive.dart';

part 'activity.g.dart';  // Generated file will be imported here

@HiveType(typeId: 0)
class Activity {
  @HiveField(0)
  final String activityName;

  @HiveField(1)
  final DateTime activityDate;

  Activity(this.activityName, this.activityDate);

  get points => null;

  get description => null;
}

@HiveType(typeId: 1)
class UserData {
  @HiveField(0)
  int points;

  @HiveField(1)
  List<Activity> activities;

  UserData({this.points = 0, this.activities = const []});
}
