import 'package:amifi/providers/UserProvider.dart';
import 'package:amifi/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/activity.dart';  // Import the generated files

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ActivityAdapter());  // Register ActivityAdapter
  Hive.registerAdapter(UserDataAdapter());  // Register UserDataAdapter

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider()..loadUserData(),
      child: MaterialApp(
        title: 'Financial Reward Tracker',
        home: HomeScreen(),
      ),
    );
  }
}
