import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/orders.dart';
import 'package:flutter_milestone_1/service/driver_firestore.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  List<Orders> driverOrders = [];

  @override
  void initState() {
    super.initState();
    loadDriverOrders();
  }

  Future<void> loadDriverOrders() async {
    try {
      List<Orders> orders = await DriverFirestoreServices.getDriverOrders();

      print("Driver Orders: $orders"); // Print orders to console

      setState(() {
        driverOrders = orders;
      });
    } catch (e) {
      print('Error loading driver orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UberX-ASU"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              "Review Your Order",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            // List of Selected Rides
            Expanded(
              child: ListView.builder(
                itemCount: driverOrders.length,
                itemBuilder: (context, index) {
                  return buildOrderItem(driverOrders[index]);
                },
              ),
            ),
            // Total Cost
            const Divider(),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildOrderItem(Orders order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${order.trip.startLocation} to ${order.trip.endLocation} - ${order.trip.tripDate}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text("Driver: ${order.trip.driverName}"),
            Text("Cost: \$${order.totalAmount}"),
            Text("Status: ${order.statusOrder.toString().split('.').last}"),
            const SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Implement your logic to remove the order
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Order removed from cart"),
                    ),
                  );
                },
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red),
                ),
                child: const Text("Remove"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
