import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/data/dummyData.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/utils/component.dart';

class RoomDetail extends StatefulWidget {
  final Room room;

  const RoomDetail({super.key, required this.room});

  @override
  State<RoomDetail> createState() => _RoomDetailState();
}

class _RoomDetailState extends State<RoomDetail> {
  bool isAddorEdit = false;

  void addorUpdate(Room room, Tenant tenant){
    system1.manageTenant(room, tenant);
    system1.updateRoom(room);
  }

  @override
  Widget build(BuildContext context) {
    final Payment? lastPayment = system1.getPaymentThisMonth(widget.room);
    final bool roomIsAvailable = widget.room.tenant == null;

    return Scaffold(
      appBar: _buildAppBar(context),
       floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Action here
    },
    child: Icon(Icons.add),
  ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              RoomDetailCard(
                title: widget.room.roomName,
                trailingAction: () {},
                children: [
                  LabelData(
                    color: roomIsAvailable
                        ? Colors.grey
                        : lastPayment?.status.color ?? Colors.black,
                    title: "Status :",
                    data: roomIsAvailable
                        ? "Available"
                        : lastPayment?.status.name ?? "N/A",
                  ),
                  LabelData(
                    title: "Price :",
                    data: '${widget.room.roomPrice} \$',
                  ),
                  LabelData(
                    title: "Landlord :",
                    data: widget.room.landlord.contact,
                  ),
                ],
              ),
              if (widget.room.tenant != null)
                RoomDetailCard(
                  title: "Tenant",
                  trailing: Text(DateFormat('dd MM yyyy').format(widget.room.tenant!.registerDate)),
                  trailingAction: () {},
                  children: [
                    LabelData(
                      title: "Identity :",
                      data: widget.room.tenant!.identity.toString(),
                    ),
                    LabelData(
                      title: "Contact :",
                      data: widget.room.tenant!.contact,
                    ),LabelData(
                      title: "Parking :",
                      data: widget.room.tenant!.rentsParking.toString(),
                    ),
                    LabelData(
                      title: "Deposit :",
                      data: "${widget.room.tenant!.deposit} \$",
                    ),
                  ],
                ),
              if (widget.room.tenant == null)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Room has no tenant"),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
        onPressed: (){
          setState(() {
            isAddorEdit = !isAddorEdit;
          });
        }, 
        icon: isAddorEdit? const Icon(Icons.check) : const Icon(Icons.edit)
        )
      ],
      title: Text(
        widget.room.roomName,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
    );
  }
}

class RoomDetailCard extends StatelessWidget {
  final String title;
  final trailing;
  final VoidCallback? trailingAction;
  final List<Widget> children;

  const RoomDetailCard({
    super.key,
    required this.title,
    this.trailing,
    this.trailingAction,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              trailing: trailing
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: children),
            ),
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

  const LabelData({
    super.key,
    required this.title,
    required this.data,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: label(title, color: color),
          trailing: Text(
            data,
            style: TextStyle(color: color, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(
            color: Theme.of(context).scaffoldBackgroundColor,
            height: 4.0,
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
