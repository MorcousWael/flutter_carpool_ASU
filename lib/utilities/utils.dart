import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_milestone_1/model/trips.dart';

class Utils {
  static List<Trip> processQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Trip(
        driverId: data['driverId'],
        driverName: data['driverName'],
        fee: data['fee'],
        mobileNumber: data['mobileNumber'],
        startLocation: data['startLocation'],
        endLocation: data['endLocation'],
        tripDate: DateTime.parse(data['tripDate']),
        statusTrip: TripStatus.values.firstWhere(
          (e) => e.toString() == 'TripStatus.${data['statusTrip']}',
        ),
      );
    }).toList();
  }
}
