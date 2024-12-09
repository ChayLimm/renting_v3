import 'dart:io';
import '../model/payment/payment.dart';
import '../model/room/room.dart';
import '../model/system/system.dart';
import '../model/system/pricecharge.dart';
import '../data/dummyData.dart';


void main() {
  final system = System();

  while (true) {
    print('Please choose an option:');
    print('1. Add Room');
    print('2. Add Price Charge');
    print('3. Process Payment');
    print('4. Update Payment Status');
    print('5. Generate Monthly Report');
    print('6. Exit');
    
    final choice = stdin.readLineSync();
    
    if (choice == '1') {
      _addRoom(system);
    } else if (choice == '2') {
      _addPriceCharge(system);
    } else if (choice == '3') {
      _processPayment(system);
    } else if (choice == '4') {
      _updatePaymentStatus(system);
    } else if (choice == '5') {
      _generateMonthlyReport(system);
    } else if (choice == '6') {
      print('Exiting...');
      break;
    } else {
      print('Invalid option, please try again.');
    }
  }
}

void _addRoom(System system) {
  print('Enter room name:');
  final roomName = stdin.readLineSync()!;
  
  print('Enter room price:');
  final roomPrice = double.parse(stdin.readLineSync()!);

  print('Enter water meter reading:');
  final waterMeter = double.parse(stdin.readLineSync()!);

  print('Enter electricity meter reading:');
  final electricityMeter = double.parse(stdin.readLineSync()!);

  final room = Room(
    roomName: roomName,
    roomPrice: roomPrice,
    landlord: landlord, // Assume landlord is added later
    tenant: null, // Assume tenant is added later
  );

  system.addRoom(room, waterMeter, electricityMeter);
  print('Room added successfully.');
}

void _addPriceCharge(System system) {
  print('Enter electricity price:');
  final electricityPrice = double.parse(stdin.readLineSync()!);

  print('Enter water price:');
  final waterPrice = double.parse(stdin.readLineSync()!);

  print('Enter parking price:');
  final rentsParkingPrice = double.parse(stdin.readLineSync()!);

  print('Enter hygiene fee:');
  final hygieneFee = double.parse(stdin.readLineSync()!); 
  
  print('Enter fine per month :');
  final finePermonth = double.parse(stdin.readLineSync()!);

  final priceCharge = PriceCharge(
    electricityPrice: electricityPrice,
    waterPrice: waterPrice,
    rentsParkingPrice: rentsParkingPrice,
    hygieneFee: hygieneFee,
    startDate: DateTime(DateTime.now().year, DateTime.now().month, 1), 
    finePerMonth: finePermonth,
    fineStartOn: DateTime(DateTime.now().year, DateTime.now().month, 5),
    endDate: null
    
  );

  system.addPriceCharge(priceCharge);
  print('Price charge added successfully.');
}

void _processPayment(System system) {
  print('Enter room name:');
  final roomName = stdin.readLineSync()!;

  print('Enter water meter reading:');
  final waterMeter = double.parse(stdin.readLineSync()!);

  print('Enter electricity meter reading:');
  final electricityMeter = double.parse(stdin.readLineSync()!);

  // Find the room by name
  final room = system.roomList.firstWhere((r) => r.roomName == roomName, orElse: () => throw Exception('Room not found'));
  
  system.processPayment(room, DateTime.now(), waterMeter, electricityMeter);
  print('Payment processed successfully.');
}

void _updatePaymentStatus(System system) {
  print('Enter room name:');
  final roomName = stdin.readLineSync()!;

  print('Enter payment timestamp (e.g., 2024-12-05):');
  final timestamp = DateTime.parse(stdin.readLineSync()!);

  print('Enter new payment status (pending, paid):');
  final statusString = stdin.readLineSync()!;
  final status = statusString == 'paid' ? PaymentStatus.paid : PaymentStatus.pending;

  final room = system.roomList.firstWhere((r) => r.roomName == roomName, orElse: () => throw Exception('Room not found'));
  
  // Find payment by timestamp
  final payment = room.paymentList.firstWhere((p) => p.timestamp == timestamp, orElse: () => throw Exception('Payment not found'));
  
  system.updatePaymentStatus(room, payment, status);
  print('Payment status updated successfully.');
}

void _generateMonthlyReport(System system) {
  print('Enter the month and year for the report (e.g., 2024-12):');
  final dateString = stdin.readLineSync()!;
  final date = DateTime.parse('$dateString-01');
  
  final report = system.generateReport(date);
  print(report);
  // Print or process the report data here (e.g., totalPrice, consumption)
}
