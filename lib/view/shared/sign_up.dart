import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_milestone_1/model/database_helper.dart';
import 'package:flutter_milestone_1/model/users.dart';
import 'package:flutter_milestone_1/service/user_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _mobilePhoneController = TextEditingController();
  var _isDriver = false;
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("UberX-ASU")),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/images/asu_circular.png'),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      hintText: 'Enter Your Name',
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.email),
                      hintText: 'Enter Your University Email',
                      labelText: 'University Email',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!value.contains('@eng.asu.edu.eg')) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.lock),
                      hintText: 'Enter Password',
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6 || value.length > 20) {
                        return 'Password must be between 6 and 20 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _mobilePhoneController,
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.phone),
                      hintText: 'Enter Your Mobile Phone',
                      labelText: 'Mobile Phone',
                      labelStyle: TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile phone';
                      } else if (!RegExp(r'^[0-9]{11}$').hasMatch(value)) {
                        return 'Invalid mobile phone format';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 5),
                  Switch(
                    value: _isDriver,
                    onChanged: (value) {
                      setState(() {
                        _isDriver = value;
                      });
                    },
                  ),
                  Column(
                    children: [
                      Text("I am a Student",
                          style: TextStyle(
                              color: _isDriver ? Colors.grey : Colors.blue)),
                      Text("I am a Driver",
                          style: TextStyle(
                              color: _isDriver ? Colors.blue : Colors.grey)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String name = _nameController.text.trim();
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      String mobilePhone = _mobilePhoneController.text.trim();
                      if (_formKey.currentState!.validate()) {
                        if (email.endsWith('@eng.asu.edu.eg')) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: (_isDriver) ? '$email.driver' : email,
                                password: password,
                              )
                              .then((value) => {
                                    UserFirestoreServices.initializeID(),
                                    UserFirestoreServices.addUser(UserandDriver(
                                      name: name,
                                      email: email,
                                      password: password,
                                      mobileNumber: mobilePhone,
                                    )),
                                  });
                          if (_isDriver) {
                            Navigator.pushNamed(context, 'driverHome');
                          } else {
                            Navigator.pushNamed(context, 'home');
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child:
                        const Text("Sign Up", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _insert() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _nameController.text.trim(),
      DatabaseHelper.columnEmail: _emailController.text.trim(),
      DatabaseHelper.columnPhone: _mobilePhoneController.text.trim(),
      DatabaseHelper.columnPassword: _passwordController.text.trim(),
    };
    final id = await dbHelper.insert(row);
    debugPrint('inserted row id: $id');
  }
}
