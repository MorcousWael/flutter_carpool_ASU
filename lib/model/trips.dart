enum TripStatus {
  pending,
  ongoing,
  completed,
}

class Trip {
  final String? driverId;
  final String driverName;

  final String mobileNumber;
  final String startLocation;
  final String endLocation;
  final DateTime tripDate;
  final double fee;
  TripStatus statusTrip = TripStatus.pending;

  Trip({
    this.driverId,
    required this.driverName,
    required this.fee,
    required this.mobileNumber,
    required this.startLocation,
    required this.endLocation,
    required this.tripDate,
    required this.statusTrip,
  });

  Map<String, dynamic> tripToJson() {
    return {
      'driverId': driverId,
      'driverName': driverName,
      'fee': fee,
      'mobileNumber': mobileNumber,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'tripDate': tripDate.toString(),
      'statusTrip': statusTrip.toString().split('.').last,
    };
  }

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
        driverId: json['driverId'] ?? '',
        driverName: json['driverName'] ?? '',
        fee: json['fee'] ?? '',
        startLocation: json['startLocation'] ?? '',
        endLocation: json['endLocation'] ?? '',
        tripDate: DateTime.parse(json['tripDate'] ?? ''),
        mobileNumber: json['mobileNumber'] ?? '',
        statusTrip: json['statusTrip'] == 'pending'
            ? TripStatus.pending
            : json['statusTrip'] == 'ongoing'
                ? TripStatus.ongoing
                : TripStatus.completed,
      );
}
