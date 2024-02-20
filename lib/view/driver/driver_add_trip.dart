import 'package:flutter/material.dart';
import 'package:flutter_milestone_1/model/trips.dart';
import 'package:flutter_milestone_1/service/driver_firestore.dart';

class DriverAddTrip extends StatefulWidget {
  const DriverAddTrip({Key? key}) : super(key: key);

  @override
  State<DriverAddTrip> createState() => _DriverAddTripState();
}

class _DriverAddTripState extends State<DriverAddTrip> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String? driverName;
  double? fee;
  String? mobileNumber;
  String? startLocation;
  String? endLocation;
  DateTime? tripDate;
  TripStatus statusTrip = TripStatus.pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Driver Name',
                    labelStyle: TextStyle(color: Colors.white), // Text color
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the driver name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    driverName = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fee',
                    labelStyle: TextStyle(color: Colors.white), // Text color
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the fee';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    fee = double.tryParse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: Colors.white), // Text color
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the mobile number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    mobileNumber = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Start Location',
                    labelStyle: TextStyle(color: Colors.white), // Text color
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the start location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    startLocation = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'End Location',
                    labelStyle: TextStyle(color: Colors.white), // Text color
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the end location';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    endLocation = value;
                  },
                ),
                //Date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Trip Date',
                          labelStyle:
                              TextStyle(color: Colors.white), // Text color
                        ),
                        style:
                            const TextStyle(color: Colors.white), // Text color
                        readOnly: true,
                        controller: TextEditingController(
                          text: _selectedDate == null
                              ? ''
                              : _selectedDate!.toString(),
                        ),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015),
                            lastDate: DateTime(2050),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the trip date';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          tripDate = DateTime.parse(value!);
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2050),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _selectedDate = pickedDate;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (["gate 4", "gate4", "gate 3", "gate3"]
                            .contains(endLocation!.toLowerCase())) {
                          _selectedDate =
                              _selectedDate!.copyWith(hour: 7, minute: 30);
                        } else {
                          _selectedDate =
                              _selectedDate!.copyWith(hour: 17, minute: 30);
                        }
                        tripDate = _selectedDate;

                        // Create a new Trip object with the entered values
                        final newTrip = Trip(
                          driverId: DriverFirestoreServices.authenticaionID,
                          driverName: driverName!,
                          fee: fee!,
                          mobileNumber: mobileNumber!,
                          startLocation: startLocation!,
                          endLocation: endLocation!,
                          tripDate: tripDate!,
                          statusTrip: statusTrip,
                        );

                        // add trip to firestore
                        DriverFirestoreServices.addTrip(newTrip);
                        // display a snackbar to confirm that the trip has been added
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Trip added successfully'),
                          ),
                        );
                      }
                    },
                    child: const Text('Add Trip'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
