import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lab345/exam_widget.dart';

class ExamPage extends StatelessWidget {
  final User? authenticatedUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return authenticatedUser == null ? _buildLoginPrompt() : _buildExamStream();
  }

  // Function to handle the case where the user is not logged in
  Widget _buildLoginPrompt() {
    return const Center(
      child: Text('Log in to view your exams.'),
    );
  }

  // Function to handle the case where the user is logged in
  Widget _buildExamStream() {
    return StreamBuilder(
      stream: _getUserExams(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading indicator while data is being fetched
        }

        if (snapshot.hasError) {
          return Text('An error occurred: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildNoExamsFoundMessage();
        }

        // Display the list of exams
        return _buildExamGrid(snapshot);
      },
    );
  }

  // Function to get the user's exams from Firestore
  Stream<QuerySnapshot> _getUserExams() {
    return FirebaseFirestore.instance
        .collection('exams')
        .where('user', isEqualTo: authenticatedUser!.uid)
        .snapshots();
  }

  // Function to display a message when no exams are found
  Widget _buildNoExamsFoundMessage() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.warning,
          color: Colors.red,
          size: 48.0,
        ),
        Text(
          'No exams found for the current user.',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    ),
  );
}

  // Function to build the grid of exams
  Widget _buildExamGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 8.0,
      children: snapshot.data!.docs.map((doc) {
        var examData = doc.data() as Map<String, dynamic>;
        return ExamWidget(
          subject: examData['name'],
          date: examData['date'],
          time: examData['time'],
          latitude: examData['latitude'],
          longitude: examData['longitude'],
        );
      }).toList(),
    );
  }
}