import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/payment/button.dart';
import 'package:pos_renting_v3/screen/receipt/receipt.dart';
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

    final Payment? thisMonthPayment = system.getPaymentThisMonth(room);
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
                        : thisMonthPayment?.status.color ?? red,
                    title: "Status :",
                    data: roomIsAvailable
                        ? "Available"
                        : thisMonthPayment?.status.name ?? "Unpaid",
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
              if(thisMonthPayment != null && thisMonthPayment.status != PaymentStatus.unpaid)...[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: 
                  (context)=>ReceiptPage(payment: thisMonthPayment)));
                },
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: thisMonthPayment!.status.color,
                    boxShadow: [shadow()],
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Center(
                    child: Text("View Receipt",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),],
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
              const SizedBox(height: 18,),

              label("History"),
              const SizedBox(height: 12,),
              PaymentHistory(room: room),
            ]
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
