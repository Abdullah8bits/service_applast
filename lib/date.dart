import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'package:service_applast/global.dart' as globals;
import 'package:service_applast/select_provider.dart';

class ScreenDate extends StatefulWidget {
  const ScreenDate({Key? key}) : super(key: key);

  @override
  State<ScreenDate> createState() => _ScreenDateState();
}

class _ScreenDateState extends State<ScreenDate> {
  DateTime? _date;

  // Function to upload selected date to Firestore
  Future<void> uploadDateToFirestore(DateTime selectedDate) async {
    try {
      await FirebaseFirestore.instance.collection('selected_dates').add({
        'selectedDate': selectedDate,
        // Add more fields as needed
      });
      print('Selected date uploaded successfully!');
    } catch (e) {
      print('Error uploading selected date: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    _dateString() {
      if (_date == null) {
        return 'Please select a date...';
      } else {
        return '${_date?.day} - ${_date?.month} - ${_date?.year}';
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_date != null) {
            // Upload the selected date to Firestore
            await uploadDateToFirestore(_date!);

            // Navigate to the next screen
            globals.setSelectedDate(_date!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenSelectProvider(),
              ),
            );
          }
        },
        child: Icon(
          Icons.arrow_forward_ios,
          size: 20,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _dateString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              textAlign: TextAlign.center,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                final result = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2010),
                  lastDate: DateTime(2050),
                );
                if (result != null) {
                  setState(() {
                    _date = result;
                  });
                }
              },
              icon: Icon(Icons.calendar_today),
              label: Text('Choose date'),
            ),
          ],
        ),
      ),
    );
  }
}
