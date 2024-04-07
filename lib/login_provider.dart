import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service_applast/register_provider.dart';
import 'package:service_applast/service_request.dart';
import 'package:service_applast/toast/toast.dart';

import 'package:service_applast/user_auth/firebase_services_auth.dart';

class ScreenLoginProvider extends StatefulWidget {
  ScreenLoginProvider({super.key});

  @override
  State<ScreenLoginProvider> createState() => _ScreenLoginProviderState();
}

class _ScreenLoginProviderState extends State<ScreenLoginProvider> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(204, 245, 242, 242),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build,
                size: 100,
              ), //welcome back!
              Text(
                'Welcome back!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Service provider, you\'ve been missed!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 50),

              //username textfield

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
                          border: InputBorder.none, hintText: 'Email'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),

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

              //sign in button
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
                      onPressed: signIn,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),

              //not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                      onPressed: () {
                        // Navigate to the provider register page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScreenRegisterProvider()),
                        );
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
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

  void signIn() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String? emailError = validateEmail(username);
    String? passwordError = validatePassword(password);
    // Check for errors
    if (emailError != null || passwordError != null) {
      showToast(
          message:
              emailError ?? passwordError ?? 'Please fill required fields');
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        // Get the userId of the logged-in user
        String userId = user.uid;

        // Fetch the service provider category using the userId
        String serviceProviderCategory = await _auth.getServiceCategory(userId);

        print("user is signed in");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenServiceRequest(
              serviceProviderCategory: serviceProviderCategory,
            ),
          ),
        );
      } else {
        showToast(message: "Some error occurred");
      }
    } catch (e) {
      showToast(message: "Error occurred during sign-in: $e");
    }
  }
}
