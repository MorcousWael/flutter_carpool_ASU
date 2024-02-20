import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/users.dart';
import 'package:flutter_milestone_1/service/user_firestore.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserandDriver>(
        future: UserFirestoreServices.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            UserandDriver userData = snapshot.data!;
            return buildProfileWidget(userData);
          }
        },
      ),
    );
  }

  Widget buildProfileWidget(UserandDriver userData) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage('https://placekitten.com/200/200'),
          ),
          const SizedBox(height: 24),
          const Text(
            'User Details:',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          buildDetailRow('Name', userData.name),
          buildDetailRow('Email', userData.email),
          buildDetailRow('Mobile Number', userData.mobileNumber),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
