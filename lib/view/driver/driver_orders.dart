import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/orders.dart';
import 'package:flutter_milestone_1/service/driver_firestore.dart';

class DriverOrders extends StatefulWidget {
  const DriverOrders({Key? key}) : super(key: key);

  @override
  State<DriverOrders> createState() => _DriverOrdersState();
}

class _DriverOrdersState extends State<DriverOrders> {
  List<Orders> driverOrders = [];

  @override
  void initState() {
    super.initState();
    loadDriverOrders();
  }

  Future<void> loadDriverOrders() async {
    try {
      List<Orders> orders = await DriverFirestoreServices.getDriverOrders();

      setState(() {
        driverOrders = orders;
        print(orders);
      });
    } catch (e) {
      print('Error loading driver orders: $e');
    }
  }

  Future<void> acceptOrder(String orderId) async {
    try {
      await DriverFirestoreServices.editOrderStatus(
          orderId, OrderStatus.accepted);
      // Refresh the list of driver orders after accepting an order
      loadDriverOrders();
    } catch (e) {
      print('Error accepting order: $e');
    }
  }

  Future<void> rejectOrder(String orderId) async {
    try {
      await DriverFirestoreServices.editOrderStatus(
          orderId, OrderStatus.rejected);
      // Refresh the list of driver orders after rejecting an order
      loadDriverOrders();
    } catch (e) {
      print('Error rejecting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("UberX-ASU")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Driver Orders",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: driverOrders.length,
                itemBuilder: (context, index) {
                  return buildOrderItem(driverOrders[index]);
                },
              ),
            ),
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
            Text("Passenger: ${order.userName}"),
            Text("Phone: ${order.phoneNo}"),
            Text("Cost: \$${order.totalAmount}"),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => acceptOrder(order.orderId!),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.tealAccent),
                  ),
                  child: const Text("Accept",
                      style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () => rejectOrder(order.orderId!),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  child: const Text("Reject",
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
