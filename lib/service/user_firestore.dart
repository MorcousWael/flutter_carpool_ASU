import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_milestone_1/model/orders.dart';
import 'package:flutter_milestone_1/model/users.dart';
import 'package:flutter_milestone_1/model/trips.dart';
import 'package:flutter_milestone_1/utilities/utils.dart';

class UserFirestoreServices {
  static final FirebaseFirestore firestoreDB = FirebaseFirestore.instance;
  static late String authenticaionID;
  final CollectionReference users = firestoreDB.collection('Users');
  final CollectionReference orders = firestoreDB.collection('Orders');
  final CollectionReference trips = firestoreDB.collection('Trip');

  static Future<void> initializeID() async {
    authenticaionID = FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> addUser(UserandDriver myuser) async {
    try {
      await firestoreDB
          .collection('Users')
          .doc(authenticaionID)
          .set(myuser.objectToJson());
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<UserandDriver> getUserInfo() async {
    try {
      final documentSnapshot =
          await firestoreDB.collection('Users').doc(authenticaionID).get();
      if (documentSnapshot.exists) {
        return UserandDriver.fromSnapshot(documentSnapshot);
      } else {
        print('Document does not exist on the database');
        return UserandDriver(
          name: '0',
          email: '0',
          password: '0',
          mobileNumber: '0',
        );
      }
    } on Exception catch (e) {
      print(e.toString());
      return UserandDriver(
        name: '0',
        email: '0',
        password: '0',
        mobileNumber: '0',
      );
    }
  }

  static Future<List<Trip>> getAllTrips() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Trip').get();

      return Utils.processQuerySnapshot(querySnapshot);
    } catch (e) {
      print('Error fetching available trips: $e');
      return [];
    }
  }

  static Future<void> addOrder(Orders order) async {
    final jsonOrder = order.orderToJson();
    jsonOrder['userId'] = authenticaionID;
    try {
      await firestoreDB.collection('Orders').add(jsonOrder);
      print('added successfully');
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future<List<Orders>> getUserOrders() async {
    final List<Orders> orders = [];
    try {
      final documentSnapshots = await firestoreDB
          .collection('Orders')
          .where(
            'userId',
            isEqualTo: authenticaionID,
          )
          .get();
      for (var doc in documentSnapshots.docs) {
        final tripItem = Orders.fromSnapshot(doc);
        orders.add(tripItem);
      }
      print(orders.length);
    } on Exception catch (e) {
      print(e.toString());
    }
    return orders;
  }
}
