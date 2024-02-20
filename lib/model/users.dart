import 'package:cloud_firestore/cloud_firestore.dart';

class UserandDriver {
  final String name;
  final String email;
  final String password;
  final String mobileNumber;

  UserandDriver(
      {required this.name,
      required this.email,
      required this.password,
      required this.mobileNumber});

  factory UserandDriver.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserandDriver(
      name: data['name'],
      email: data['email'],
      password: data['password'],
      mobileNumber: data['mobileNumber'],
    );
  }

  Map<String, dynamic> objectToJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'mobileNumber': mobileNumber,
    };
  }
}
