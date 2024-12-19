import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart'; // Importing the fl_chart package

import '../models/activity.dart';
import '../providers/UserProvider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reward Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              // Navigate to profile or settings page
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Points Section
            _buildPointsSection(userProvider),
            SizedBox(height: 20),

            // Log Activity Button
            _buildLogActivityButton(userProvider),

            SizedBox(height: 20),

            // Activity List Section
            _buildActivityList(userProvider, context),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsSection(UserProvider userProvider) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Points',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '${userProvider.userData.points}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Keep logging activities to earn more points!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogActivityButton(UserProvider userProvider) {
    return ElevatedButton(
      onPressed: () {
        userProvider.addActivity('Saving Money');
        userProvider.saveUserData();
      },
      child: Text('Log Activity'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent, // Button color
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildActivityList(UserProvider userProvider, BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: userProvider.userData.activities.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the Activity Details screen with an animated transition
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => ActivityDetailsScreen(
                    activity: userProvider.userData.activities[index],
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOut;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    var offsetAnimation = animation.drive(tween);
                    return SlideTransition(position: offsetAnimation, child: child);
                  },
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  userProvider.userData.activities[index].activityName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(
                  'Date: ${userProvider.userData.activities[index].activityDate}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityDetailsScreen extends StatelessWidget {
  final Activity activity;

  ActivityDetailsScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity.activityName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Activity Name:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                activity.activityName,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Activity Date
              Text(
                'Activity Date:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                activity.activityDate.toString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Description Section
              Text(
                'Description:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                activity.description ?? 'No description provided',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),

              // Points Earned
              Text(
                'Points Earned:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '${activity.points}',
                style: TextStyle(fontSize: 16, color: Colors.green),
              ),
              SizedBox(height: 20),

              // Chart Section - Points over time (Example)
              Text(
                'Activity Progress:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildActivityChart(),
              SizedBox(height: 20),

              // Mark as Completed Button
              ElevatedButton(
                onPressed: () {
                  // You can add actions here, such as marking the activity as completed
                },
                child: Text('Mark as Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to generate the chart
  Widget _buildActivityChart() {
    return Container(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 7, // Example: 7 days in a week
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 20),
                FlSpot(1, 40),
                FlSpot(2, 60),
                FlSpot(3, 80),
                FlSpot(4, 90),
                FlSpot(5, 60),
                FlSpot(6, 100),
              ],
              isCurved: true,
              color: Colors.blueAccent,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.3)),
            ),
          ],
        ),
      ),
    );
  }
}
