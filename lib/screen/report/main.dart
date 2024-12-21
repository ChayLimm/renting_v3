import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/report.dart';
import 'package:pos_renting_v3/utils/component.dart';

class ReportPage extends StatelessWidget {
  final Function(BuildContext,DateTime) triggerUpdate;
  final MonthlyReport report;
  const ReportPage(
      {super.key,
      required this.report,
      required this.triggerUpdate
      });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM yyyy').format(report.forMonth);


    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin:  const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(left: 12, bottom: 10,right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      "Income",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "${report.paidRoom}/${report.roomList.length} has",
                            style: const TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: " paid",
                            style: TextStyle(color: green),
                          ),
                        ],
                      ),
                    ),
                    trailing: TextButton(child: Text(formattedDate),
                      onPressed: () async {
                        final pickDated =await selectDate(context);
                        triggerUpdate(context,pickDated!);
                      },
                    ),
                  ),
                ],
              ),
            ),
            customeList(Icons.bolt, "Electricity", "${report.totalElectricityConsumption}", "${report.totalElectricityPrice}\$"),
            customeList(Icons.water_drop, "Water", "${report.totalWaterConsumption}", "${report.totalWaterPrice}\$"),
            customeList(Icons.cleaning_services, "Hygiene", "${report.totalHygienePrice}", "${report.totalHygienePrice}\$"),
            customeList(Icons.local_parking, "Parking", " ${report.totalParking}", "${report.totalParkingRentPrice}\$"),
            customeList(Icons.bed, "Room", "${report.paidRoom}", "${report.totalRoomPrice}\$"),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: green
              ),
              child: ListTile(
                title:const Text("Total",style: TextStyle(color: Colors.white),),
                trailing: Text("${report.overallPrice.toStringAsFixed(2)}\$",style:const TextStyle(color: Colors.white,fontSize: 16),),
                
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget customeList(IconData iconData,String title, String usage, String total){
    return Container(
      margin:  const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Row(children: [
            Icon(iconData,color: grey,size: 20,),
            const SizedBox(width: 6,),
            Text(title)
          ],)),
          Expanded(flex: 1,child: Align(alignment: Alignment.centerLeft, child: Text(usage))),
          Expanded(flex: 1,child: Align(alignment: Alignment.centerRight, child: Text(total))),
        ],
      ),
    );
  }
}