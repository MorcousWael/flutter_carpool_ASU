import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_milestone_1/model/orders.dart';
import 'package:flutter_milestone_1/model/trips.dart';
import 'package:flutter_milestone_1/model/users.dart';
import 'package:flutter_milestone_1/service/user_firestore.dart';

class Routes extends StatefulWidget {
  const Routes({Key? key}) : super(key: key);

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  List<Trip> allTrips = [];
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();
  bool disableconstraint = false;
  UserandDriver user = UserandDriver(
    name: 'Ahmed',
    email: '',
    password: '',
    mobileNumber: '',
  );

  @override
  void initState() {
    super.initState();
    loadAllTripsData();
  }

  Future<void> loadAllTripsData() async {
    try {
      List<Trip> trips = await UserFirestoreServices.getAllTrips();

      setState(() {
        allTrips = trips;
      });
    } catch (e) {
      print('Error loading all trips: $e');
    }
  }

  bool _canReserve(Trip trip) {
    final Duration difference = trip.tripDate.difference(DateTime.now());
    if (disableconstraint) {
      return true;
    }
    if (trip.endLocation == "gate 3" ||
        trip.endLocation == "gate 4" ||
        trip.endLocation == "gate3" ||
        trip.endLocation == "gate4") {
      if (difference.inHours > 10 ||
          difference.inHours == 9 && difference.inMinutes.remainder(60) > 30) {
        return true;
      }
    } else {
      if (difference.inHours > 5 ||
          (difference.inHours == 4 &&
              difference.inMinutes.remainder(60) > 30)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _reserveTrip(Trip trip) async {
    Orders order = Orders(
      trip: trip,
      statusOrder: OrderStatus.pending,

      phoneNo: trip.mobileNumber,
      userName: user.name,
      totalAmount: trip.fee,

      // You need to set appropriate values based on your data model

      // Set other properties based on your data model and the trip
      // For example, you might use trip.driverName, trip.mobileNumber, etc.
    );

    // Add the order to Firestore
    await UserFirestoreServices.addOrder(order);

    // Create an Orders object from the Trip
  }

  void _showPaymentSheet(Trip trip) {
    showModalBottomSheet(
      isScrollControlled: true, // Set to true for a full-height bottom sheet
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CreditCardWidget(
                  cardNumber: cardNumberController.text,
                  expiryDate: expiryDateController.text,
                  cardHolderName: cardHolderNameController.text,
                  cvvCode: cvvCodeController.text,
                  showBackView: false,
                  onCreditCardWidgetChange: (CreditCardBrand) {},
                ),
                TextFormField(
                  controller: cardNumberController,
                  decoration: const InputDecoration(labelText: 'Card Number'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: expiryDateController,
                  decoration: const InputDecoration(labelText: 'Expiry Date'),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: cardHolderNameController,
                  decoration:
                      const InputDecoration(labelText: 'Cardholder Name'),
                ),
                TextFormField(
                  controller: cvvCodeController,
                  decoration: const InputDecoration(labelText: 'CVV'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Assuming payment is successful, reserve the trip
                    _reserveTrip(trip);
                    Navigator.pop(context); // Close the bottom sheet
                  },
                  child: const Text('Pay and Reserve'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Trips'),
      ),
      body: Column(children: [
        Row(
          children: [
            const Text('Disable Constraint',
                style: TextStyle(color: Colors.white)),
            Checkbox(
                value: disableconstraint,
                onChanged: (value) {
                  setState(() {
                    disableconstraint = value!;
                  });
                }),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: allTrips.length,
            itemBuilder: (context, index) {
              final trip = allTrips[index];
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
                      Text(
                          'Status: ${trip.statusTrip.toString().split('.').last}'),
                      Text('Trip Date: ${trip.tripDate.toString()}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      if (!_canReserve(trip)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'You cannot reserve this trip. Please select another trip.'),
                          ),
                        );
                        return;
                      }
                      // Handle the button press to show payment sheet
                      _showPaymentSheet(trip);
                    },
                    child: const Text('Reserve'),
                  ),
                  onTap: () {
                    // Handle trip selection
                  },
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
