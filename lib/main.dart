// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/database_helper.dart';
import 'package:flutter_milestone_1/view/driver/driver_add_trip.dart';
import 'package:flutter_milestone_1/view/driver/driver_home.dart';
import 'package:flutter_milestone_1/view/driver/driver_orders.dart';
import 'package:flutter_milestone_1/view/driver/driver_trips.dart';
import 'package:flutter_milestone_1/view/shared/profile.dart';
import 'package:flutter_milestone_1/view/user/home.dart';
import 'package:flutter_milestone_1/view/user/routes.dart';
import 'package:flutter_milestone_1/view/shared/sign_in.dart';
import 'package:flutter_milestone_1/view/user/user_orders.dart';
import 'package:flutter_milestone_1/view/shared/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init(); // Ensure that init is called first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); //MaterialApp
}

final ThemeData myTheme = ThemeData(
  primaryColor: const Color(0xFF252526),
  scaffoldBackgroundColor: const Color(0xFF252526),
  appBarTheme: const AppBarTheme(
    color: Color(0xff737070),
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: const SignIn(),
      routes: {
        'signIN': (context) => const SignIn(),
        'home': (context) => const Home(),
        'route': (context) => const Routes(),
        'userOrders': (context) => const UserOrders(),
        'signUp': (context) => const SignUp(),
        'driverTrips': (context) => const DriverTrips(),
        'driverHome': (context) => const DriverHome(),
        'driveraddTrip': (context) => const DriverAddTrip(),
        'driverOrders': (context) => const DriverOrders(),
        'profile': (context) => ProfileScreen(key: UniqueKey()),
      },
    );
  }
}
