import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:service_applast/toast/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(String email, String password,
      {Map<String, dynamic>? extraDetails}) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = credential.user!.uid;

      // Store additional details in Firebase Firestore
      if (extraDetails != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set(extraDetails);
      }

      return credential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e.message); // Print the error message to the console
        showToast(message: e.message as String);
      }
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print(e.message); // Print the error message to the console
        showToast(message: e.message as String);
      }
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> fetchUserDataWithCategory(
      String category) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('serviceCategory', isEqualTo: category)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> userList = [];

        for (var doc in querySnapshot.docs) {
          var userData = doc.data() as Map<String, dynamic>;
          userData['docId'] = doc.id;
          userList.add(userData);
        }
        return userList;
      } else {
        // Handle the case when no documents match the query
        showToast(message: 'No user found for the category: $category');
      }
    } catch (e) {
      if (e is FirebaseException) {
        print(e.message); // Print the error message to the console
        showToast(message: e.message!);
      }
    }
    return null;
  }

  Future<String> getServiceCategory(String userId) async {
    try {
      // Fetch the user document based on the provided userId
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // Retrieve user data
        var userData = userSnapshot.data() as Map<String, dynamic>;

        // Extract the service category from user data
        String? serviceProviderCategory = userData['serviceCategory'];

        if (serviceProviderCategory != null) {
          return serviceProviderCategory;
        } else {
          // Handle the case when service category is null
          throw Exception('Service category not found for userId: $userId');
        }
      } else {
        // Handle the case when no user document is found
        throw Exception('User not found with userId: $userId');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error fetching service category: $e');
      throw Exception('Error fetching service category: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> fetchUserorders() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> userList = [];

        for (var doc in querySnapshot.docs) {
          var userData = doc.data() as Map<String, dynamic>;
          userData['docId'] = doc.id;
          userList.add(userData);
        }
        return userList;
      } else {
        // Handle the case when no documents match the query
        showToast(message: 'No user found for Orders');
      }
    } catch (e) {
      if (e is FirebaseException) {
        print(e.message); // Print the error message to the console
        showToast(message: e.message!);
      }
    }
    return null;
  }

  Future<void> createOrder(String docId, String detail) async {
    try {
      // Fetch user data using docId
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(docId).get();

      if (userDoc.exists) {
        // Extract user data
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Create a new order document
        await FirebaseFirestore.instance.collection('orders').add({
          'userId': docId,
          'orderId': generateRandomOrderId(),
          'status': 'sended',
          'orderDetails': detail,
          'providerDetails': userData,
          'category':
              userData['serviceCategory'], // Include category information
          'timestamp': FieldValue.serverTimestamp(),
        });

        showToast(message: 'Order created successfully!');
      } else {
        showToast(message: 'User not found with docId: $docId');
      }
    } catch (e) {
      if (e is FirebaseException) {
        print(e.message);
        showToast(message: e.message!);
      }
    }
  }
}

String generateRandomOrderId({int length = 10}) {
  Random random = Random();
  String orderId = '';

  for (int i = 0; i < length; i++) {
    orderId += random.nextInt(10).toString(); // Generates a random digit (0-9)
  }

  return orderId;
}
