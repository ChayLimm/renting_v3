import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/payment/button.dart';
import 'package:pos_renting_v3/screen/room/history.dart';
import 'package:pos_renting_v3/screen/room/roomForm.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class RoomDetail extends StatelessWidget {
  final Room room;

  const RoomDetail({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<System>(context)  ;// to access the System instance

    final Payment? lastPayment = system.getPaymentThisMonth(room);
    final bool roomIsAvailable = room.tenant == null;

    return Scaffold(
      appBar: _buildAppBar(context),
      floatingActionButton: roomIsAvailable ? 
      FloatingActionButton.extended(
        onPressed: (){
         Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomForm(room: room,isEditingTenant:  true)));
        },
      backgroundColor: grey,
      label: const Text("Register",style: TextStyle(color: Colors.white),),
      icon: const Icon(Icons.person,color: Colors.white,),
        )
       : PaymentButton(room: room,),
      
      body: Consumer<System>(builder: (context,system,child){
        return  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoomDetailCard(
                title: room.roomName,
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
                    data: '${room.roomPrice} \$',
                  ),
                  LabelData(
                    title: "Landlord :",
                    data: room.landlord.contact,
                  ),
                ],
              ),
              if (room.tenant != null)
                RoomDetailCard(
                  title: "Tenant",
                  trailing: Text(DateFormat('dd MM yyyy')
                      .format(room.tenant!.registerDate)),
                  trailingAction: () {},
                  children: [
                    LabelData(
                      title: "Identity :",
                      data: room.tenant!.identity.toString(),
                    ),
                    LabelData(
                      title: "Contact :",
                      data: room.tenant!.contact,
                    ),
                    LabelData(
                      title: "Parking :",
                      data: room.tenant!.rentsParking.toString(),
                    ),
                    LabelData(
                      title: "Deposit :",
                      data: "${room.tenant!.deposit} \$",
                    ),
                  ],
                ),
              const SizedBox(height: 10,),
              // if (room.tenant == null)
              //    ...[GestureDetector(
              //     onTap: (){
              //       Navigator.push(context, MaterialPageRoute(builder: (context)=>RoomForm(room: room,isEditingTenant:  true)));
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.all(4.0),
              //       child: DottedBorder(
              //         color: Colors.grey,
              //         strokeWidth: 1,
              //         dashPattern: [6, 6], // Longer dash and more space
              //         borderType: BorderType.RRect,
              //         radius: const Radius.circular(10), // Increased radius
              //         child:  Container(
              //           width: double.infinity,
              //           height: 64,
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8)
              //           ),
              //           child: const  Center(child: Text("Add tenant",),),
              //         ),
              //       ),
              //     )

              //   )],
                const SizedBox(height: 8,),
                label("History"),
                const SizedBox(height: 12,),
                PaymentHistory(room: room),
            ],
          ),
        ),
      );
    
      })
      
     
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RoomForm(room: room)));
            },
            icon: const Icon(Icons.edit))
      ],
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
                trailing: trailing),
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
