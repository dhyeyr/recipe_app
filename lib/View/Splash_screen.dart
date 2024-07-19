import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'Screens/Home Page.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
          () {
        Get.off(
          Home_Screen(),
        );
      },
    );
    super.initState();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        width: MediaQuery.sizeOf(context).width * 4,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/splash.png"),fit: BoxFit.fitHeight),),
      ),
    );
  }
}
