import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/utils/component.dart';

class RoomDetail extends StatelessWidget {
  final Room room;
  const RoomDetail({super.key,required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          room.roomName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        )),
      ),
      body: Padding(
        padding:  EdgeInsets.all(20),
        child: Column(children: [
          label("Room Details"),
        ],
        ),
        ),

    );
  }
}