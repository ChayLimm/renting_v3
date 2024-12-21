import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/report.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/homepage/roomList.dart';
import 'package:pos_renting_v3/screen/homepage/status_widget.dart';
import 'package:pos_renting_v3/screen/room/roomForm.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  final List<Room> roomList;
  const MyHomePage({super.key, required this.roomList});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MonthlyReport? report;

  List<Widget> pages = [];

  List<Room> available = [];
  List<Room> unpaid = [];
  List<Room> pending = [];
  List<Room> paid = [];
  List<Room> passData = [];




  void updateStatus() {
   
    print("udpateSatusfunction invoke");
    final system = Provider.of<System>(context,listen: false);
      available.clear();
      unpaid.clear();
      pending.clear();
      paid.clear();

      for (var room in widget.roomList) {
        Payment? lastPayment = system.getPaymentThisMonth(room);
        bool isAvailable =
            room.getRoomAvailability() == RoomAvailability.available;
        bool isUnpaid = lastPayment == null ||
            (lastPayment.status == PaymentStatus.unpaid &&
                room.getRoomAvailability() != RoomAvailability.available);
        bool isPending = lastPayment == null ||
            (lastPayment.status == PaymentStatus.pending &&
                room.getRoomAvailability() != RoomAvailability.available);
        bool isPaid = lastPayment == null ||
            (lastPayment.status == PaymentStatus.paid &&
                room.getRoomAvailability() != RoomAvailability.available);

        if (isAvailable) available.add(room);
        if (isUnpaid) unpaid.add(room);
        if (isPending) pending.add(room);
        if (isPaid) paid.add(room);
      }
   
  }

  void selectedGroupBy(PaymentStatus? sortBy) {
     print("udpateSatusfunction invoke");
    passData.clear();

    switch (sortBy) {
      case PaymentStatus.unpaid:
        passData.addAll(unpaid);
        passData.addAll(available);
        passData.addAll(pending);
        passData.addAll(paid);
        break;
      case PaymentStatus.pending:
        passData.addAll(pending);
        passData.addAll(available);
        passData.addAll(unpaid);
        passData.addAll(paid);
        break;
      case PaymentStatus.paid:
        passData.addAll(paid);
        passData.addAll(available);
        passData.addAll(unpaid);
        passData.addAll(pending);
        break;
      case null:
        passData.addAll(available);
        passData.addAll(unpaid);
        passData.addAll(pending);
        passData.addAll(paid);
        break;
    }

    setState(() {});
  }

 

  @override
  void initState() {
    super.initState();
    final system = Provider.of<System>(context, listen: false);
    passData = widget.roomList;
    updateStatus();
  }
  

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context, system, child) {
      print("rebuilll");
      updateStatus();
      return Scaffold(      
        body:Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusWidget(
              available: available.length,
              paid: paid.length,
              unpaid: unpaid.length,
              pending: pending.length,
              selectedGroupBy: selectedGroupBy,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                label("Room"),
                GestureDetector(
                  onTap: () {
                    updateStatus();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RoomForm()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [shadow()]),
                    child: const Text(
                      "Add room",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: RoomListView(
                key: ValueKey(DateTime.now()),
                roomList: passData,
              ),
            ),
          ],
        ),
      )
,
      );
    });
  }

 
}
