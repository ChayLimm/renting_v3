import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'screen/homepage/main.dart';
import 'package:flutter/material.dart';
import 'package:pos_renting_v3/data/dummyData.dart';

void main() {
  //sampledata
  Tenant tenant1 = Tenant(contact: "165498",identity: 13213, rentsParking: 1,deposit: 50);
  system1.manageTenant(system1.roomList[0], tenant1);
  system1.processPayment(system1.roomList[0], DateTime.now(), 200, 200);
 
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
