import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/report.dart';
import 'package:pos_renting_v3/utils/component.dart';

class ReportPage extends StatelessWidget {
  final List<PriceCharge> priceChargeList;
  final List<Room> roomList;
  final DateTime forMonth;
  const ReportPage(
      {super.key,
      required this.priceChargeList,
      required this.roomList,
      required this.forMonth});

  @override
  Widget build(BuildContext context) {
    final MonthlyReport report = MonthlyReport(
        priceChargeList: priceChargeList,
        roomList: roomList,
        forMonth: forMonth);

    String formattedDate = DateFormat('MMMM yyyy').format(forMonth);


    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin:  const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  onTap: (){
                    // report.printReportDetails();
                  },
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    "Income",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                  subtitle: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${report.paidRoom}/${roomList.length} has",
                          style: const TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: " paid",
                          style: TextStyle(color: green),
                        ),
                      ],
                    ),
                  ),
                  trailing: Text(formattedDate,style: const TextStyle(fontSize: 12),),
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
