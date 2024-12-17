import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/main.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/homepage/roomList.dart';
import 'package:pos_renting_v3/screen/homepage/status_widget.dart';
import 'package:pos_renting_v3/screen/report/main.dart';
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
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  
  List<Widget> pages = [];

  String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
  List<Room> available = [];
  List<Room> unpaid = [];
  List<Room> pending = [];
  List<Room> paid = [];
  List<Room> passData = [];

  void updateStatus(System system) {
    setState(() {
      available.clear();
      unpaid.clear();
      pending.clear();
      paid.clear();

      for (var room in widget.roomList) {
        Payment? lastPayment = system.getPaymentThisMonth(room);

        bool isAvailable = room.getRoomAvailability() == RoomAvailability.available;
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
    });
  }

  void selectedGroupBy(PaymentStatus? sortBy) {
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
    final system =  Provider.of<System>(context, listen: false);
    updateStatus(system);
    passData = widget.roomList;
    pages = [
      mainPage(),
      ReportPage(priceChargeList: system.priceChargeList, roomList: system.roomList, forMonth: DateTime.now()),  
      Center(child: Text('Pricing Page'))   
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context, system, child) {
      return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: blue,

          animationDuration: Duration(milliseconds: 300),
          items:  <Widget>[
             Icon(Icons.home, size: 32,color: grey,),
            Icon(Icons.summarize, size: 32,color: grey,),
            Icon(Icons.price_change, size: 32,color: grey,),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     Navigator.push(
        //       context, 
        //       MaterialPageRoute(builder: (context) => RoomForm())
        //     );
        //   },
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(16.0),
        //   ),
        //   backgroundColor: Colors.white,
        //   elevation: 5.0,
        //   label:  Text("Add room",style: TextStyle(color: blue),),
        //   icon:  Icon(Icons.add,color: blue,),
        // ),
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
        body: pages[_page],
      );
    });
  }

  Padding mainPage() => Padding(
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  label("Room"),
GestureDetector(
  onTap: () {
 Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => RoomForm())
            );  },
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [shadow()]
    ),
    child: Text("Add room",style: TextStyle(fontSize: 12,color: blue,fontWeight: FontWeight.w500),),
  ),
)
        ],),
        const SizedBox(height: 12),
        Expanded(
          child: RoomListView(
            key: ValueKey(DateTime.now()),
            roomList: passData,
          ),
        ),
      ],
    ),
  );
}
