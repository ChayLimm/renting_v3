import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'screen/homepage/main.dart';
import 'package:flutter/material.dart';
import 'package:pos_renting_v3/data/dummyData.dart';

void main() {
  //sampledata
  initializeDummyData();
  Tenant tenant1 = Tenant(contact: "165498",identity: "013213", rentsParking: 1,deposit: 50);

  system1.manageTenant(system1.roomList[0], tenant1);
  system1.manageTenant(system1.roomList[1], tenant1);
  system1.manageTenant(system1.roomList[2], tenant1);


  system1.processPayment(system1.roomList[0], DateTime.now(), 200, 200);
  system1.processPayment(system1.roomList[1], DateTime.now(), 200, 200);
  system1.updatePaymentStatus(system1.roomList[0],system1.roomList[0].paymentList.last,PaymentStatus.paid);
 
  runApp(MainApp(system: system1,));
}

class MainApp extends StatelessWidget {
  final System system;
  const MainApp({super.key,required this.system});
  @override
  Widget build(BuildContext context) {
 
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F8),
        primaryColor: Colors.white,
      ),
      home: MyHomePage(roomList: system.roomList),
    );
  }
}
