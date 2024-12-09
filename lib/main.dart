import 'package:pos_renting_v3/model/system/system.dart';
import 'screen/homepage/main.dart';
import 'package:flutter/material.dart';
import 'package:pos_renting_v3/data/dummyData.dart';

void main() {
  System system1 = System();
  //sampledata
  system1.addPriceCharge(priceCharge);
  system1.addRoom(room1,100,100);
  system1.addRoom(room2,100,100);
  system1.addRoom(room3,100,100);
  system1.addRoom(room4,100,100);
  system1.addRoom(room5,100,100);
  system1.addRoom(room6,100,100);
 
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
