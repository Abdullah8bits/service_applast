// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:service_applast/global.dart' as globals;
import 'package:service_applast/service_confirm.dart';

import 'package:service_applast/user_auth/firebase_services_auth.dart';

String? selectedUser;

class ScreenServiceRequest extends StatefulWidget {
  final String serviceProviderCategory;

  const ScreenServiceRequest({
    Key? key,
    required this.serviceProviderCategory,
  }) : super(key: key);

  @override
  State<ScreenServiceRequest> createState() => _ScreenServiceRequestState();
}

class _ScreenServiceRequestState extends State<ScreenServiceRequest> {
  final FirebaseAuthService db_service = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    // Call the function when the page initializes
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
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
                'Order Summary',
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
                    return Text('No Order');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      // Get the service provider's category
      String serviceProviderCategory =
          widget.serviceProviderCategory; // Replace with actual category

      QuerySnapshot ordersSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      List<Map<String, dynamic>> orders = [];

      for (QueryDocumentSnapshot orderDoc in ordersSnapshot.docs) {
        Map<String, dynamic> orderData =
            orderDoc.data() as Map<String, dynamic>;
        String userId = orderData['userId'];

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          String userCategory =
              userData['serviceCategory']; // Get the category of the user

          // Check if the user's category matches the service provider's category
          if (userCategory == serviceProviderCategory) {
            Map<String, dynamic> combinedData = {
              ...orderData,
              'firstName': userData['firstName'],
              'lastName': userData['lastName'],
              'phone': userData['phone'],
              'gender': userData['gender'],
              'category': userCategory, // Include category information
            };

            orders.add(combinedData);
          }
        }
      }

      // Fetch the selected date
      DateTime? selectedDate = globals.getSelectedDate();

      // Add the selected date to the order details
      for (Map<String, dynamic> order in orders) {
        order['selectedDate'] = selectedDate;
      }

      return orders;
    } catch (e) {
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
          var category = '${user['category'] ?? ''}';
          var phone = user['phone'] ?? '';
          var gender = user['gender'] ?? '';
          var selectedDate =
              user['selectedDate'] as DateTime?; // Retrieve selected date

          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
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
                  Row(
                    children: [
                      Icon(Icons.category, size: 16, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Category: $category',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
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
                      Icon(Icons.person_outline, size: 16, color: Colors.blue),
                      SizedBox(width: 5),
                      Text(
                        'Gender: $gender',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  // Show selected date
                  if (selectedDate != null) ...[
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 16, color: Colors.blue),
                        SizedBox(width: 5),
                        Text(
                          'Selected Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                  Row(
                    // Center the buttons horizontally
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Accept button

                      // Cancel button
                      ElevatedButton(
                        onPressed: () {
                          acceptOrder(user);
                        },
                        child: Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          cancelOrder(user);
                        },
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

//ScreenServiceRequest
void acceptOrder(Map<String, dynamic> user) async {
  try {
    // Update the order status in Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(user['TtOY2u8viOFbX2lxONnn'])
        .update({'status': 'accepted'});

    // Notify the user
    // Implement your notification logic here

    print('Order accepted for user: ${user['fullName']}');
  } catch (e) {
    print('Error accepting order: $e');
  }
}

void cancelOrder(Map<String, dynamic> user) async {
  try {
    // Update the order status in Firestore
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(user['orderId'])
        .update({'status': 'cancelled'});

    // Notify the user
    // Implement your notification logic here

    print('Order cancelled for user: ${user['fullName']}');
  } catch (e) {
    print('Error cancelling order: $e');
  }
}
