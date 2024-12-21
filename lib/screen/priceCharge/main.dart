import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/priceCharge/form.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:pos_renting_v3/utils/device.dart';
import 'package:provider/provider.dart';

class PriceChargePage extends StatelessWidget {
  final List<PriceCharge> priceChargeList;
  const PriceChargePage({super.key, required this.priceChargeList});

  void addPriceCharge(BuildContext context, PriceCharge priceCharge){
    final system = Provider.of<System>(context);
    system.addPriceCharge(priceCharge);
    showCustomSnackBar(context, "Added Price Charge Successfully", green);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context,system,child){
      return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            label("Price Charge"),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                decoration: BoxDecoration(
                  boxShadow: [shadow()],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child:const Center(
                  child:  Text("Add"),
                ),
              ),
              onTap:(){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)
                  =>PriceForm(triggerAdd: addPriceCharge,)));
              }
            )
          ],),
          const SizedBox(
            height: 16,
          ),
          Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: DeviceType.isMobile(context) ? 1 : 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 3 / 2.5,
                  ),
                  itemCount: priceChargeList.length,
                  itemBuilder: (context, index) {
                    return customeCard(priceChargeList.reversed.toList()[index]);
                  }))
        ],
      ),
    );
  
    });
    
   
  }

  Widget customeCard(PriceCharge priceCharge) {
    final bool isValid = priceCharge.isValidDate(DateTime.now());
    final String startDate = DateFormat('dd/MM/yyyy').format(priceCharge.startDate);
    final String fineDate = DateFormat('dd/MM/yyyy').format(priceCharge.fineStartOn);
    late String endDate;

    if (priceCharge.endDate != null) {
      endDate = DateFormat('dd/MM/yyyy').format(priceCharge.endDate!);
    }else{
      endDate = "---";
    }
    
    return Container(
        padding: const EdgeInsets.only(top: 4, left: 12,right :12,bottom: 16),
        width: double.infinity,
        decoration: BoxDecoration(
                color: isValid? Colors.white : Color(0xffD3D3D3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [          
                ListTile(
                  contentPadding: EdgeInsets.zero,
                    title: Text("Start : $startDate"),
                    subtitle: Text("End : $endDate"),
                    trailing: Text(
                      isValid ? "Valid" : "Invalid",
                      style: TextStyle(
                        color: isValid ? green : red,
                        fontSize: 18
                      ),
                    ),               
                ),
          
                const Divider(
                  color: Colors.grey, 
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                  ),
                  Expanded(child: buildDetailRow("Electricity :", "${priceCharge.electricityPrice}\$/KwH")),
                  Expanded(child: buildDetailRow("Water :", "${priceCharge.waterPrice}\$/m³")),
                  Expanded(child: buildDetailRow("Hygeine :", "${priceCharge.hygieneFee}\$/room")),
                  Expanded(child: buildDetailRow("Rents Parkign :", "${priceCharge.rentsParkingPrice}\$/room")),
                  Expanded(child: buildDetailRow("Penalty :", "${priceCharge.finePerDay}\$/Day")),
                  Expanded(child: buildDetailRow("Penalty Start on:", fineDate)),
              
              ],
        
        ),
      
    );
  }
}
