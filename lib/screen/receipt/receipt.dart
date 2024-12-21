import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class ReceiptPage extends StatelessWidget {
  final Payment payment;
  const ReceiptPage({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {

    late Payment lastPayment;
    if(payment.room.paymentList.isNotEmpty){
      lastPayment   = payment.consumption.lastpayment!;
    }

  final bool isfine = payment.fine > 0;

  final system = Provider.of<System>(context);
  final lastPaidDate = DateFormat('dd/MM/yyyy').format(lastPayment.timestamp);
  final currentPaidDate = DateFormat('dd/MM/yyyy').format(payment.timestamp);

  final PriceCharge priceCharge= system.getValidPriceCharge(payment.timestamp);

  final double waterUsed = payment.consumption.waterMeter - lastPayment.consumption.waterMeter ;
  final double electricityUsed= payment.consumption.electricityMeter - lastPayment.consumption.electricityMeter ;

  final double totalWater = waterUsed *priceCharge.waterPrice ;
  final double totalElec  = electricityUsed *priceCharge.electricityPrice;
  final double totalParking = payment.tenant!.rentsParking * priceCharge.rentsParkingPrice;
  final double deposit = payment.deposit;
  final double fine = payment.fine;
  final double subtotal =  payment.totalPrice - fine - deposit;
  final double total = payment.totalPrice;
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white,),
      body: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text("វិក័យប័ត្រ",style: TextStyle(fontSize: 28),),
            ),
            const SizedBox(height: 10,),
            Row(children: [
              const Text("បន្ទប់លេខ : "),
              Text(payment.room.roomName)
            ],),
            Row(children: [
              const Text("ទូរស័ព្ទម្ចាស់ផ្ទះលេខ : "),
              Text(payment.room.landlord.contact)
            ],),
            Row(children: [
              const Text("រយៈពេលស្នាក់នៅពី : "),
              Text(lastPaidDate),
              const Text(" ដល់ "),
              Text(currentPaidDate),
            ],),
            const SizedBox(height: 24,),
         Table( 
          children: [
            TableRow(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(' '), 
                ),
                Center(child: label('លេខចាស់')), 
                Align(
                  alignment: Alignment.centerRight,
                  child: label('លេខថ្មី'), 
                ),
              ],
            ), // Row for water meter
            TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label('ទឹក'), 
                ),
                Center(
                  child: Text(lastPayment.consumption.waterMeter.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(payment.consumption.waterMeter.toStringAsFixed(2)), 
                ),
              ],
            ),
           
            TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label('ភ្លើង'), // Left-aligned label
                ),
                Center(
                  child: Text(lastPayment.consumption.electricityMeter.toStringAsFixed(2)),  
                ),
               
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(payment.consumption.electricityMeter.toStringAsFixed(2)),  
                ),
              ],
            ),
          ],
        ),
         Container(margin:const EdgeInsets.symmetric(vertical:10),
          child: const Divider(thickness: 1, color: Colors.grey,)),
        Table( 
          children: [
            TableRow(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(' '), 
                ),
                Center(child: label('បរិមាណ')),
                const Center(child: Text("តម្លៃ"), 
                ), 
                Align(
                  alignment: Alignment.centerRight,
                  child: label('សរុប'), 
                ),
              ],
            ), // Row for water meter
            TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label('ទឹក'), 
                ),
                Center(
                  child: Text(waterUsed.toStringAsFixed(2)), 
                ),
                Center(
                  child: Text(priceCharge.waterPrice.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(totalWater.toStringAsFixed(2)), 
                ),
              ],
            ),
           
            TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label('ភ្លើង'), // Left-aligned label
                ),
                Center(
                  child: Text(electricityUsed.toStringAsFixed(2)),  
                ),
                Center(
                  child: Text(priceCharge.electricityPrice.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(totalElec.toStringAsFixed(2)),  
                ),
              ],
            ),
            TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label("ម៉ូតូ"), // Left-aligned label
                ),
                Center(
                  child: Text(payment.tenant!.rentsParking.toStringAsFixed(2)),  
                ),
                Center(
                  child: Text(priceCharge.rentsParkingPrice.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(totalParking.toStringAsFixed(2)),  
                ),
              ],
            ), TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label("អនាម័យ"), // Left-aligned label
                ),
                 Center(
                  child: Text(priceCharge.hygieneFee.toStringAsFixed(2)),  
                ),
                 Center(
                  child: Text(priceCharge.hygieneFee.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(priceCharge.hygieneFee.toStringAsFixed(2)),  
                ),
              ],
            ), TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label("បន្ទប់"), // Left-aligned label
                ),
                const Center(
                  child: Text("1"),  
                ),
                Center(
                  child: Text(payment.room.roomPrice.toStringAsFixed(2)), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(payment.room.roomPrice.toStringAsFixed(2)),  
                ),
              ],
            ),
            if(deposit >0)...[
              TableRow(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: label("លុយកក់"), // Left-aligned label
                ),
                const Center(
                  child: Text("1"),  
                ),
                const Center(
                  child: Text(" "), 
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(deposit.toStringAsFixed(2)),  
                ),
              ],
            ),
            ]
            
          ],
        ),
Container(margin:const EdgeInsets.symmetric(vertical:10),
          child: const Divider(thickness: 1, color: Colors.grey,)),
   Table( 
          children: [
         
            TableRow(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('សរុប'), 
                ),
              
                Align(
                  alignment: Alignment.centerRight,
                  child: label(subtotal.toStringAsFixed(2)), 
                ),
              ],
            ),
             //fine
          if(isfine)
            TableRow(
              children: [
                 Align(
                  alignment: Alignment.centerLeft,
                  child: Text('ពិន័យ',style: TextStyle(color: red),), 
                ),
              
                Align(
                  alignment: Alignment.centerRight,
                  child: label(payment.fine.toStringAsFixed(2),color: red), 
                ),
              ],
            ),
          if(deposit>0)
            //deposit
            TableRow(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('លុយកក់'), 
                ),
              
                Align(
                  alignment: Alignment.centerRight,
                  child: label(deposit.toStringAsFixed(2)), 
                ),
              ],
            ),
          if(deposit>0 || isfine)
            TableRow(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('សរុប'), 
                ),
              
                Align(
                  alignment: Alignment.centerRight,
                  child: label(total.toStringAsFixed(2)), 
                ),
              ],
            ),
              ]
          
          
        ),
        

          ],
        ),
      ),
    );
  }
}