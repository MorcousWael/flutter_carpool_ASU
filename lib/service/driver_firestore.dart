import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_milestone_1/model/orders.dart';
import 'package:flutter_milestone_1/model/trips.dart';
import 'package:flutter_milestone_1/utilities/utils.dart';

class DriverFirestoreServices {
  static final FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  static late String authenticaionID;
  final CollectionReference users = firestoreDB.collection('Users');
  final CollectionReference orders = firestoreDB.collection('Orders');
  final CollectionReference trips = firestoreDB.collection('Trip');

  static Future<void> initializeID() async {
    authenticaionID = FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> addTrip(Trip trip) async {
    try {
      await firestoreDB.collection('Trip').add(trip.tripToJson());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<List<Trip>> getTripsForDriver(String driverId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Trip')
          .where('driverId', isEqualTo: driverId)
          .get();

      return Utils.processQuerySnapshot(querySnapshot);
    } catch (e) {
      print('Error fetching trips: $e');
      return [];
    }
  }

  static Future<List<Orders>> getDriverOrders() async {
    final List<Orders> orders = [];
    try {
      final documentSnapshots = await firestoreDB.collection('Orders').get();
      for (var firestoreorders in documentSnapshots.docs) {
        if (firestoreorders.data()['trip']['driverId'] == authenticaionID) {
          final tripItem = Orders.fromSnapshot(firestoreorders);
          orders.add(tripItem);
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
    return orders;
  }

  static Future<void> editOrderStatus(
      String orderId, OrderStatus newStatus) async {
    final body = {
      'statusOrder': newStatus.toString().split('.').last,
    };
    try {
      await firestoreDB.collection('Orders').doc(orderId).update(body);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
