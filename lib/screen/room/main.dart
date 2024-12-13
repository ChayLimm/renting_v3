import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/data/dummyData.dart';
import 'package:pos_renting_v3/utils/component.dart';

class RoomDetail extends StatelessWidget {
  final Room room;
  const RoomDetail({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final Payment? lastPayment = system1.getPaymentThisMonth(room);
    final bool unpaid = lastPayment == null;
    final bool roomIsAvailable = room.tenant == null;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          room.roomName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 12),
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        room.roomName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 28,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ),
                    
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(children: [
                           LabelData(
                            color: roomIsAvailable ? Colors.grey : lastPayment!.status.color,
                            title: "Status :",
                            data: roomIsAvailable ? "Available" : lastPayment!.status.name,
                          ),
                          LabelData(
                            title: "Price :",
                            data: '${room.roomPrice.toString()} \$',
                          ),
                          LabelData(
                            title: "Landlord :",
                            data: room.landlord.contact,
                          ),
                          
                        ])
                        )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LabelData extends StatelessWidget {
  final String title;
  final String data;
  final Color color;
  LabelData({
    super.key,
    required this.data,
    required this.title,
    this.color =Colors.black
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
          title: label(title,color: color),
          trailing: Text( 
            data,
            style: TextStyle(color: color, fontSize: 18),
          )),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Divider(
          color: Theme.of(context).scaffoldBackgroundColor,
          height: 4.0,
          thickness: 1.0,
        ),
      )
    ]);
  }
}

  //  Text(
                //   lastPayment!.status.name,
                //   style: TextStyle(color: lastPayment.status.color),
                // ),
