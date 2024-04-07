// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:service_applast/login_provider.dart';
import 'package:service_applast/login_seeker.dart';

class ScreenSeekerOrProvider extends StatefulWidget {
  const ScreenSeekerOrProvider({Key? key}) : super(key: key);

  @override
  State<ScreenSeekerOrProvider> createState() => ScreenSeekerOrProviderState();
}

class ScreenSeekerOrProviderState extends State<ScreenSeekerOrProvider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the Column vertically
          children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                minimumSize: MaterialStateProperty.all(Size(200, 40)),
                textStyle: MaterialStateProperty.all(TextStyle(
                  fontSize: 20,
                )),
              ),
              onPressed: () {
                // Navigate to the seeker login page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScreenLoginSeeker()),
                );
              },
              child: Text("whether a service seeker?"),
            ),
            SizedBox(height: 16), // Add some space between the buttons
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
                minimumSize: MaterialStateProperty.all(Size(200, 40)),
                textStyle: MaterialStateProperty.all(TextStyle(
                  fontSize: 20,
                )),
              ),
              onPressed: () {
                // Navigate to the provider login page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScreenLoginProvider()),
                );
              },
              child: Text("whether a service provider?"),
            ),
          ],
        ),
      ),
    );
  }
}
