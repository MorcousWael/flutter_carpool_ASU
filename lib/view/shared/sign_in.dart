import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_milestone_1/service/driver_firestore.dart';
import 'package:flutter_milestone_1/service/user_firestore.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  var _isDriver = false;
  final _formKey = GlobalKey<FormState>();

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
                  const SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      if (_formKey.currentState?.validate() ?? false) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: (_isDriver) ? '$email.driver' : email,
                          password: password,
                        )
                            .then((userCredential) async {
                          if (_isDriver) {
                            await DriverFirestoreServices.initializeID();
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, 'driverHome');
                          } else {
                            await UserFirestoreServices.initializeID();
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, 'home');
                          }
                        }).catchError((error) {
                          // Authentication failed, print error message
                          print(error);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child:
                        const Text("Sign In", style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'signUp');
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
}
