// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:service_applast/seeker_or_provider.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => ScreenSplashState();
}

class ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    goToSeekerOrProvider();
    super.initState();
  }

  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.jpg'),
      ),
    );
  }

  Future<void> goToSeekerOrProvider() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctxt) => ScreenSeekerOrProvider()));
  }
}
