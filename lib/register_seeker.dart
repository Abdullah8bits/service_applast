// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:service_applast/login_seeker.dart';
import 'package:service_applast/service_list.dart';
import 'package:service_applast/toast/toast.dart';
import 'package:service_applast/user_auth/firebase_services_auth.dart';

class ScreenRegisterSeeker extends StatefulWidget {
  const ScreenRegisterSeeker({super.key});

  @override
  State<ScreenRegisterSeeker> createState() => _ScreenRegisterSeekerState();
}

class _ScreenRegisterSeekerState extends State<ScreenRegisterSeeker> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(204, 245, 242, 242),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.android,
                  size: 100,
                ),

                //Hello there!!
                Text(
                  'Hello there!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Register with your credentials!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 50),

                // email textfield

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'email'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                //service provided

                //password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'password'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // confirm password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _confirmpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'confirm password'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                // sign up button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Container(
                    padding: EdgeInsets.only(left: 1.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.deepPurple),
                          minimumSize: MaterialStateProperty.all(
                            Size(625, 40),
                          ),
                          textStyle: MaterialStateProperty.all(TextStyle(
                            fontSize: 20,
                          )),
                        ),
                        onPressed: () {
                          //navigate to the service list page
                          signUp();
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                // Already a member! login now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                        onPressed: () {
                          //Navigate to the seeker login page
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenLoginSeeker()));
                        },
                        child: Text(
                          'Login now',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter your email address';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  void signUp() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmpassword = _confirmpasswordController.text;

    String? emailError = validateEmail(username);
    String? passwordError = validatePassword(password);
    // Check for errors
    if (emailError != null || passwordError != null) {
      showToast(
          message:
              emailError ?? passwordError ?? 'Please fill required fields');
      return;
    }
    if (password == confirmpassword) {
      Map<String, dynamic> extraDetails = {
        "service_provider": false
        // Add more fields as needed
      };
      User? user =
          await _auth.register(username, password, extraDetails: extraDetails);
      if (user != null) {
        print("user is successfully created");
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScreenServiceList()));
      } else {
        showToast(message: "Some error occured");
      }
    } else {
      showToast(message: "password should be same as confirm password");
    }
  }
}
