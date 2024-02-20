import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/trips.dart';
import 'package:flutter_milestone_1/service/driver_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DriverTrips extends StatefulWidget {
  const DriverTrips({Key? key}) : super(key: key);

  @override
  State<DriverTrips> createState() => _DriverTripsState();
}

class _DriverTripsState extends State<DriverTrips> {
  List<Trip> trips = [];

  @override
  void initState() {
    super.initState();
    loadTripsData();
  }

  Future<void> loadTripsData() async {
    try {
      String authenticationId = FirebaseAuth.instance.currentUser!.uid;
      List<Trip> driverTrips =
          await DriverFirestoreServices.getTripsForDriver(authenticationId);

      setState(() {
        trips = driverTrips;
      });
    } catch (e) {
      print('Error loading trips: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Card(
            child: ListTile(
              title: Text(trip.driverName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mobile Number: ${trip.mobileNumber}'),
                  Text('Fee: \$${trip.fee.toStringAsFixed(2)}'),
                  Text('Start Location: ${trip.startLocation}'),
                  Text('End Location: ${trip.endLocation}'),
                  Text('Status: ${trip.statusTrip.toString().split('.').last}'),
                  Text('Trip Date: ${trip.tripDate.toString()}'),
                ],
              ),
              onTap: () {
                // Handle trip selection
              },
            ),
          );
        },
      ),
    );
  }
}
