import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("UberX-ASU"), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
        ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                children: [
                  const Text("Welcome to UberX-ASU!",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      )),
                  const Text(
                    "Search for routes to and from ASU",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 30),
                  // get image from assets
                  Image.asset('assets/images/asu_building.png'),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'route');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                          double.infinity, 40), // Set minimum button size
                    ),
                    child: const Text("Available Routes",
                        style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'userOrders');
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(
                          double.infinity, 40), // Set minimum button size
                    ),
                    child: const Text("Orders", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
