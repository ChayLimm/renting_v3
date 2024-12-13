import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/screen/homepage/roomList.dart';
import 'package:pos_renting_v3/screen/homepage/status_widget.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:pos_renting_v3/data/dummyData.dart';

class MyHomePage extends StatefulWidget {
  final List<Room> roomList;
  const MyHomePage({super.key, required this.roomList});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
  List<Room> available = [];
  List<Room> unpaid = [];
  List<Room> pending = [];
  List<Room> paid = [];
  List<Room> passData = [];

  void updateStatus() {
    setState(() {
      available.clear();
      unpaid.clear();
      pending.clear();
      paid.clear();

      for (var room in widget.roomList) {
        Payment? lastPayment = system1.getPaymentThisMonth(room);

        bool isAvailable = room.getRoomAvailability()== RoomAvailability.available; 
        bool isUnpaid = lastPayment == null || lastPayment!.status == PaymentStatus.unpaid && room.getRoomAvailability() != RoomAvailability.available;
        bool isPending = lastPayment == null || lastPayment!.status == PaymentStatus.pending && room.getRoomAvailability() != RoomAvailability.available;
        bool isPaid = lastPayment == null || lastPayment!.status == PaymentStatus.paid && room.getRoomAvailability() != RoomAvailability.available;

        if (isAvailable) {
          available.add(room);
        }if(isUnpaid){
          unpaid.add(room);
        }else if(isPending){
          pending.add(room);
        }else if(isPaid){
          paid.add(room);
        }

      
       
      }
    }
    );
  }

  void selectedGroupBy(PaymentStatus? sortBy) {
    passData!.clear();

    switch (sortBy) {
      case PaymentStatus.unpaid:
        setState(() {
          // Add all rooms from unpaid first, followed by available, pending, and paid
          passData.addAll(unpaid);
          passData.addAll(available);
          passData.addAll(pending);
          passData.addAll(paid);
        });
        break;
      case PaymentStatus.pending:
        setState(() {
          passData.addAll(pending);
          passData.addAll(available);
          passData.addAll(unpaid);
          passData.addAll(paid);
        });
        break;
      case PaymentStatus.paid:
        setState(() {
          passData.addAll(paid);
          passData.addAll(available);
          passData.addAll(unpaid);
          passData.addAll(pending);
        });
        break;
      case null:
        setState(() {
          passData.addAll(available);
          passData.addAll(unpaid);
          passData.addAll(pending);
          passData.addAll(paid);
        });
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    passData = widget.roomList;
    updateStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          date,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
      ),
      body: Padding(
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
            const SizedBox(
              height: 24,
            ),
            label("Room"),
            const SizedBox(
              height: 16,
            ),
            Expanded(
                child: RoomListView(
              key: ValueKey(DateTime.now()),
              roomList: passData,
            ))
          ],
        ),
      ),
    );
  }
}
