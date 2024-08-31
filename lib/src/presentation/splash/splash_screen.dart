
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:your_dictionary/src/presentation/resources/color_manager.dart';

import '../resources/routes_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((_) {
      Navigator.pushReplacementNamed(context, Routes.homeRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Write Your",
                style: TextStyle(
                  fontSize: 30,
                  color: ColorManager.white,
                ),
              ),
              Text(
                "Dictionary",
                style: TextStyle(
                  fontSize: 60,
                  color: ColorManager.white,
                ),
              )
            ],
          ),
        ).animate().blurXY(
              duration: 750.ms,
              begin: 10,
              end: 0,
            ),
      ),
    );
  }
}
