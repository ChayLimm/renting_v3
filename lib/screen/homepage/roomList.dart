import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/room/main.dart';
import 'package:pos_renting_v3/utils/device.dart';
import 'package:provider/provider.dart';

class RoomListView extends StatefulWidget {
  final List<Room> roomList;
  const RoomListView({super.key, required this.roomList});

  @override
  State<RoomListView> createState() => _RoomListViewState();
}

class _RoomListViewState extends State<RoomListView> {
  late List<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    _resetAnimation();
  }
  

  @override
  void didUpdateWidget(RoomListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetAnimation(); // Reset animation on widget update.
  }

  void _resetAnimation() {
    _isVisible = List.generate(widget.roomList.length, (_) => false);
    _animateItems();
  }

  void _animateItems() {
    for (int i = 0; i < widget.roomList.length; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (mounted) {
          setState(() {
            _isVisible[i] = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.roomList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: DeviceType.isMobile(context) ? 2 : 4,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 3 / 1.5,
      ),
      itemBuilder: (context, index) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isVisible[index] ? 1.0 : 0.0,
          child: RoomCard(room: widget.roomList[index]),
        );
      },
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final String subtitle = room.tenant?.contact ?? "None";

    // Check if the last payment is for the current month and year
    final Payment? payment = Provider.of<System>(context).getPaymentThisMonth(room);

    return Card(
      color: room.tenant != null ? payment!.status.color : Colors.grey,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RoomDetail(room: room)));
        },
        child: ListTile(
          title: Text(
            room.roomName,
            style: const TextStyle(
                fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
