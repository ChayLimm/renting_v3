import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/screen/homepage/roomList.dart';
import 'package:pos_renting_v3/screen/homepage/status_widget.dart';
import 'package:pos_renting_v3/utils/component.dart';


class MyHomePage extends StatefulWidget {
  final List<Room> roomList;
  const MyHomePage({super.key,required this.roomList});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
  List<Room> available = [];
  List<Room> unpaid = [];
  List<Room> pending = [];
  List<Room> paid = [];



  void updateStatus() {
  setState(() {
    available.clear();
    unpaid.clear();
    pending.clear();
    paid.clear();

    for (var room in widget.roomList) {
      // Check if the room is available
      if (room.getRoomAvailability() == RoomAvailability.available) {
        available.add(room);
        continue;
      }

      if (room.paymentList.isNotEmpty) {
        Payment lastPayment = room.paymentList.last;

        if (lastPayment.timestamp.month == DateTime.now().month &&
            lastPayment.timestamp.year == DateTime.now().year) {
          if (lastPayment.status == PaymentStatus.paid) {
            paid.add(room);
          } else {
            pending.add(room);
          }
        } else {
          unpaid.add(room); 
        }
      } else {
        unpaid.add(room);
      }
    }
   }
  );
}

  @override
  void initState() {
    // TODO: implement initState
    updateStatus();
    super.initState();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(date,style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18
        ),),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )
        ),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: 
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusWidget(available: available.length,paid: paid.length,unpaid: unpaid.length,pending: pending.length,),
              const SizedBox(height: 24,),
              label("Room"),
              const SizedBox(height: 16,),
              Expanded(child: RoomListView(roomList: widget.roomList,))
            ],
          ),
        ),
        
    );
  }
}