import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/data/dummyData.dart';
import 'package:pos_renting_v3/screen/main.dart';
import 'package:provider/provider.dart';
import 'screen/homepage/main.dart';

void main() {
  // Initialize the dummy data  
  // Create tenant instance
  Tenant tenant1 = Tenant(contact: "165498", identity: "013213", rentsParking: 1, deposit: 50);
  
  // Create and manage tenants in system
  System system = System(); // Initialize the System instance

  system.addPriceCharge(newPriceCharge);
  system.addRoom(room1, 100, 100);
  system.addRoom(room2, 100, 100);
  system.addRoom(room3, 100, 100);
  system.addRoom(room4, 100, 100);
  system.addRoom(room5, 100, 100);
  system.addRoom(room6, 100, 100);

  system.manageTenant(system.roomList[0], tenant1);
  system.manageTenant(system.roomList[1], tenant2);
  system.manageTenant(system.roomList[2], tenant3);
  
  // Process payments
  system.processPayment(system.roomList[0], DateTime.now(), 200, 200);
  system.processPayment(system.roomList[1], DateTime.now(), 200, 200);
  system.updatePaymentStatus(system.roomList[0], system.roomList[0].paymentList.last, PaymentStatus.paid);

  // Run the app with the System instance being managed by Provider
  runApp(MyApp(system: system));
}

class MyApp extends StatelessWidget {
  final System system;

  const MyApp({super.key, required this.system});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide System instance to the widget tree
        ChangeNotifierProvider(
          create: (context) => system, // Pass system instance to the provider
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF2F2F8),
          primaryColor: Colors.white,
        ),
        home: AppController(system: system), // Pass data to your homepage
      ),
    );
  }
}
