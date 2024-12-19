import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/activity.dart';

class ActivityProgressChart extends StatelessWidget {

  final List<Activity> activities;

  ActivityProgressChart(this.activities, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: charts.BarChart(
        _createActivityData(activities),
        animate: true,
      ),
    );
  }

  List<charts.Series<Activity, String>> _createActivityData(List<Activity> activities) {
    Map<String, int> activityCount = {};

    // Group activities by date
    for (var activity in activities) {
      String date = activity.activityDate.toString().substring(0, 10);
      activityCount[date] = (activityCount[date] ?? 0) + 1;
    }

    // Convert the map to a list of Activity objects with the date as domain and count as measure
    List<Activity> chartData = [];
    activityCount.forEach((date, count) {
      chartData.add(Activity(date, DateTime.now()));  // Reusing Activity class for structure
    });

    // Returning the correct types for domain (String) and measure (int)
    return [
      charts.Series<Activity, String>(
        id: 'Activity',
        domainFn: (Activity activity, _) => activity.activityName, // Here, we're using activityName for the domain
        measureFn: (Activity activity, _) => activityCount[activity.activityName],  // Using the count for measure
        data: chartData,
      ),
    ];
  }
}
