import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';

class RoomListView extends StatelessWidget {
  final List<Room> roomList;
  const RoomListView({super.key, required this.roomList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: roomList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5, 
        mainAxisSpacing: 5, 
        childAspectRatio: 3 / 1.5,
      ),
      itemBuilder: (context, index) {
        return RoomCard(room: roomList[index]);
      },
    );
  }
}
class RoomCard extends StatelessWidget {
  final Room room;
  const RoomCard({super.key,required this.room});

  @override
  Widget build(BuildContext context) {

    final String subtitle = room.tenant != null ? room.tenant!.contact : "None";
    final Payment? payment = 
          room.paymentList.last.timestamp.month == DateTime.now().month &&
          room.paymentList.last.timestamp.year == DateTime.now().year ? 
          room.paymentList.last : null ;
    
    return Card(
      color: Colors.white, 
      child:
      ListTile(
      leading: Icon(Icons.circle,color: payment != null ? payment.status.color : Colors.grey ,size: 20,),
       title: Text(room.roomName,style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16
       ),),
       subtitle: Text(subtitle,style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
       ),),
    ));
  }
}
