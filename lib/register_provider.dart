// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:service_applast/login_provider.dart';
import 'package:service_applast/service_request.dart';
import 'package:service_applast/toast/toast.dart';
import 'package:service_applast/user_auth/firebase_services_auth.dart';

class ScreenRegisterProvider extends StatefulWidget {
  const ScreenRegisterProvider({super.key});

  @override
  State<ScreenRegisterProvider> createState() => _ScreenRegisterProviderState();
}

class _ScreenRegisterProviderState extends State<ScreenRegisterProvider> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    super.dispose();
  }

  String selectedGender = '';
  ///////////////////////////////////////////////////////////////////////////////
  String selectedService = 'Cleaning';

  List<String> services = [
    'Cleaning',
    'Plumber',
    'Electrician',
    'Painter',
    'Carpenter',
    'Gardener',
    'Tailor',
    'Maid',
    'Driver',
    'Cook',
  ];
//////////////////////////////////////////////////////////////////////////
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
                  Icons.build,
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
                  'Registration for service provider!',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 50),

                // first name

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
                        controller: _firstnameController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'First Name'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                //last name
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
                        controller: _lastnameController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Last Name'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
////////////////////////////////////////////////////////////////////
                // service specialized in dropdown

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
                      child: Row(
                        children: [
                          Text(
                            'Service Specialized In:',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          DropdownButton<String>(
                            value: selectedService,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedService = newValue!;
                              });
                            },
                            items: services.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

////////////////////////////////////////////////////////////////////////
                //phone number
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
                        controller: _phoneController,
                        keyboardType: TextInputType
                            .number, // Set the keyboard type to number
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number', // Update the hint text
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

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
                        controller: _emailController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Email'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
//gender
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Gender:',
                        style: TextStyle(fontSize: 15),
                      ),
                      Row(
                        children: [
                          Radio(
                            value: 'Male',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value.toString();
                              });
                            },
                          ),
                          Text('Male'),
                          Radio(
                            value: 'Female',
                            groupValue: selectedGender,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value.toString();
                              });
                            },
                          ),
                          Text('Female'),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
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
                        obscureText: true,
                        controller: _passwordController,
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
                          //Navigate to the provider login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenLoginProvider()),
                          );
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

  // Validation functions
  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return 'Please enter your first name';
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  String? validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Add more specific validation for phone number if needed
    return null;
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

  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    } else if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  void signUp() async {
    String firstName = _firstnameController.text;
    String lastName = _lastnameController.text;
    String phone = _phoneController.text;
    String username = _emailController.text;
    String password = _passwordController.text;
    String confirmpassword = _confirmpasswordController.text;

    // Validate each field
    String? firstNameError = validateFirstName(firstName);
    String? lastNameError = validateLastName(lastName);
    String? phoneError = validatePhoneNumber(phone);
    String? emailError = validateEmail(username);
    String? passwordError = validatePassword(password);
    String? confirmPasswordError =
        validateConfirmPassword(password, confirmpassword);

    // Check for errors
    if (firstNameError != null ||
        lastNameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null) {
      showToast(
          message: firstNameError ??
              lastNameError ??
              emailError ??
              passwordError ??
              phoneError ??
              'Please fill required fields');
      return;
    }

    Map<String, dynamic> extraDetails = {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'serviceCategory': selectedService, // Include service category
      'gender': selectedGender,
      // Add more fields as needed
    };

    if (password == confirmpassword) {
      User? user =
          await _auth.register(username, password, extraDetails: extraDetails);
      if (user != null) {
        print("user is successfully created");
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenServiceRequest(
              serviceProviderCategory:
                  selectedService, // Pass the selected category
            ),
          ),
        );
      } else {
        showToast(message: "Some error occured");
      }
    } else {
      showToast(message: "password should be same as confirm password");
    }
  }
}
