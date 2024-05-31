import 'dart:async';
import 'package:meal_planner/Components/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:meal_planner/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              appLogo,
              size: 120,
              color: primaryColor,
            )
          ],
        ),
      ),
      //),
    );
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  Future onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString("email");

    if (email == null) {
      pushAndRemoveUntil(context, LoginScreen());
    } else {
      pushAndRemoveUntil(context, const HomeScreen());
    }
  }
}
