import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_milestone_1/model/trips.dart';

enum OrderStatus { pending, accepted, rejected, none }

class Orders {
  String? orderId;
  String? userId;
  final String userName;
  final String phoneNo;
  final double totalAmount;
  final Trip trip;
  OrderStatus statusOrder;

  Orders({
    required this.trip,
    this.orderId,
    this.userId,
    required this.statusOrder,
    required this.userName,
    required this.phoneNo,
    required this.totalAmount,
  });
  Map<String, dynamic> orderToJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'phoneNo': phoneNo,
      'totalAmount': totalAmount,
      'trip': trip.tripToJson(),
      'statusOrder': statusOrder.toString().split('.').last,
    };
  }

  factory Orders.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Orders(
        orderId: document.id,
        userId: data['userId'],
        userName: data['userName'],
        phoneNo: data['phoneNo'],
        trip: Trip.fromJson(data['trip']),
        statusOrder: data['statusOrder'] == 'pending'
            ? OrderStatus.pending
            : data['statusOrder'] == 'accepted'
                ? OrderStatus.accepted
                : data['statusOrder'] == 'rejected'
                    ? OrderStatus.rejected
                    : OrderStatus.none,
        totalAmount: data['totalAmount'],
      );
    }
    return Orders(
      orderId: document.id,
      userId: '',
      userName: '',
      phoneNo: '',
      trip: Trip(
        driverId: '',
        driverName: '',
        fee: 0,
        mobileNumber: '',
        startLocation: '',
        endLocation: '',
        tripDate: DateTime.now(),
        statusTrip: TripStatus.pending,
      ),
      statusOrder: OrderStatus.none,
      totalAmount: 0,
    );
  }
}
