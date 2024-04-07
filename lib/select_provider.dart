// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:service_applast/global.dart' as globals;
import 'package:service_applast/service_confirm.dart';

import 'package:service_applast/user_auth/firebase_services_auth.dart';

String? selectedUser;

class ScreenSelectProvider extends StatefulWidget {
  const ScreenSelectProvider({super.key});

  @override
  State<ScreenSelectProvider> createState() => _ScreenSelectProviderState();
}

class _ScreenSelectProviderState extends State<ScreenSelectProvider> {
  final FirebaseAuthService db_service = FirebaseAuthService();
  var selectedService = globals.getSelectedCategory() ?? '';

  @override
  void initState() {
    super.initState();
    // Call the function when the page initializes
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    print(selectedService);
    return Scaffold(
      backgroundColor: Color.fromARGB(204, 245, 242, 242),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Icon(
                  Icons.home_repair_service_outlined,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              Text(
                'Please select a service provider',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // If the Future is still running, show a loader
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If the Future throws an error, show an error message
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data != null) {
                    // If the Future is completed, show the actual data
                    List<Map<String, dynamic>> user = snapshot.data!;
                    return UserListWidget(userList: user);
                  } else {
                    // Handle the case when no documents match the query
                    return Text(
                        'No users found for the category: $selectedService');
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenServiceConfirm(),
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      return await db_service.fetchUserDataWithCategory(selectedService) ?? [];
    } catch (e) {
      // Handle errors if needed
      print('Error fetching user data: $e');
      return [];
    }
  }
}

class UserListWidget extends StatefulWidget {
  final List<Map<String, dynamic>> userList;

  UserListWidget({required this.userList});

  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Column(
        children: widget.userList.map((user) {
          var fullName = '${user['firstName'] ?? ''} ${user['lastName'] ?? ''}';
          var phone = user['phone'] ?? '';
          var gender = user['gender'] ?? '';

          return GestureDetector(
            onTap: () {
              setState(() {
                // Update the selected user
                selectedUser = user["docId"];
                globals.setSelectedUserDocId(user["docId"]);
              });
            },
            child: Card(
              margin: EdgeInsets.all(8.0),
              elevation: 4.0,
              color: selectedUser == user["docId"] as String
                  ? Colors.blue.withOpacity(0.1)
                  : null,
              child: ListTile(
                leading: Icon(Icons.person, size: 40, color: Colors.blue),
                title: Text(
                  fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'Phone: $phone',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.person_outline,
                            size: 16, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'Gender: $gender',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
