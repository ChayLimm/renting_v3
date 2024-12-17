import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class PaymentHistory extends StatelessWidget {
  final Room room;
  const PaymentHistory({super.key, required this.room});

  @override
  Widget build(BuildContext context) {

    final paymentList = room.paymentList;
    final Payment? thisMonthPayment = Provider.of<System>(context).getPaymentThisMonth(room,DateTime.now());
    
    final bool roomIsAvailable = room.tenant == null;
    Color textColor = thisMonthPayment == null ? Colors.black : Colors.white;
    

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      child: Column(
        children: [
            Container(
              decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
              color: roomIsAvailable ? Colors.grey : thisMonthPayment!.status.color,

              ),
              padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
              child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                Expanded(child: Text("Room",style: TextStyle(color: textColor),)),
                Expanded(child: Text("Electricity",style: TextStyle(color: textColor),)),
                Expanded(child: Text("Water",style: TextStyle(color: textColor),)),
                Expanded(child: Text("Date",style: TextStyle(color: textColor),)),
              ],),
                       ),
           
          ...paymentList.map((toElement)=>infoTile(toElement))

        ],
      ),
    );
  }

  Container infoTile(Payment payment){
    final consumption = payment.consumption;
    final formatedDate = DateFormat('dd/MM/yyyy').format(payment.timestamp);
    return  Container(
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFF2F2F8))),

      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Expanded(child: Text(payment.room.roomName)),
        Expanded(child: Text(consumption.electricityMeter.toString())),
        Expanded(child: Text(consumption.electricityMeter.toString())),
        Expanded(child: Text(formatedDate)),
      ],),
    );
  }
}

