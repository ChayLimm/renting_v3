import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final Room room;
  const PaymentPage({super.key, required this.room});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late System system;
  late PriceCharge priceCharge;
  late Payment lastPayment;

  double waterMeter = 0;
  double electricityMeter = 0;

  double waterUsed = 0;
  double electricityUsed = 0;

  double totalWater = 0;
  double totalElec = 0;

  double total = 0;

  late double totalParking;
  late int rentParking;
  late double roomPrice;
  late double deposit;

  late double lastElectricity;
  late double lastWater;

  late int daysDiff;

  @override
  void initState() {
    super.initState();
    system = Provider.of<System>(context, listen: false);
    priceCharge = system.getValidPriceCharge(DateTime.now());
    lastPayment = widget.room.paymentList.last;
    lastElectricity = lastPayment.consumption.electricityMeter;
    lastWater = lastPayment.consumption.waterMeter;
    roomPrice = widget.room.roomPrice;
    deposit = system.getDepositPrice(widget.room);

    totalParking = widget.room.tenant!.rentsParking * priceCharge.rentsParkingPrice;
    rentParking = widget.room.tenant!.rentsParking;

    daysDiff = DateTime.now().difference(lastPayment.timestamp).inDays;
    totalPrice();
  }

  void totalPrice() {
    setState(() {
      total = totalParking +
          totalWater +
          totalElec +
          priceCharge.hygieneFee +
          widget.room.roomPrice+
          deposit;
    });
  }

  void _updateElectricity(String value) {
    setState(() {
      electricityMeter = double.tryParse(value) ?? 0;
      electricityUsed = electricityMeter - lastElectricity;
      totalElec = electricityUsed * priceCharge.electricityPrice;
      totalPrice();
    });
  }

  void _updateWater(String value) {
    setState(() {
      waterMeter = double.tryParse(value) ?? 0;
      waterUsed = waterMeter - lastWater;
      totalWater = waterUsed * priceCharge.waterPrice;
      totalPrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if(_formKey.currentState!.validate()){
            bool agree = await showAgreementDialog(context,"Are you sure","Electricity metter = ${electricityMeter}\nWater meter = ${waterMeter} ");
            if(agree){
              system.processPayment(
                widget.room, 
                DateTime.now(), 
                waterMeter, 
                electricityMeter
              );
              showCustomSnackBar(context,"Payment Completed!",green);
              Navigator.pop(context);
              Navigator.pop(context);
            }else{
              showCustomSnackBar(context,"Rejected!",red);
            }
          }
        },
        backgroundColor: blue,
        label: const Text("Submit",style: TextStyle(color: Colors.white),),

        ),
      appBar: AppBar(
        title: Text("Payment for ${widget.room.roomName}"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details Container
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Color(0xFFBBBBBB)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label("Details :"),
                    const SizedBox(height: 10),
                    _buildDetailRow("Room :", widget.room.roomName),
                    _buildDetailRow(
                      "Room's Price :",
                      "${widget.room.roomPrice} \$",
                    ),
                    _buildDetailRow(
                        "Electricity Meter :", lastElectricity.toString()),
                    _buildDetailRow("Water Meter :", lastWater.toString()),
                    _buildDetailRow("Stay duration :", daysDiff.toString()),
                  ],
                ),
              ),

              // Payment This Month
              label("Payment This Month"),
              const SizedBox(height: 18),

              _buildTextFormField(
                suffix: "KwH",
                keyboardType: TextInputType.number,
                label: "Electricity's Meter",
                onChanged: _updateElectricity,
                validator: (value) => _validateInput(value, lastElectricity),
              ),
              const SizedBox(height: 10),
              _buildTextFormField(
                suffix: "m³",
                keyboardType: TextInputType.number,
                label: "Water's Meter",
                onChanged: _updateWater,
                validator: (value) => _validateInput(value, lastWater),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10),
                child: const Divider(color: Colors.grey, thickness: 1),
              ),
              _buildUsageRow("Electricity Usage", "${electricityUsed.toStringAsFixed(2)}", totalElec),
              _buildUsageRow(
                  "Water Usage", "${waterUsed.toStringAsFixed(2)}", totalWater),
              _buildUsageRow("Hygiene", "1", priceCharge.hygieneFee),
              _buildUsageRow(
                  "Rent Parking", rentParking.toString(), totalParking),
              _buildUsageRow("Room", "1", widget.room.roomPrice),
             
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Divider(color: Colors.grey, thickness: 1),
              ),

              _buildSimpleRow("Total", "${(total-deposit).toStringAsFixed(2)} \$", isBold: true),
               if(deposit>0)...[
              _buildSimpleRow("Deposit","${deposit.toStringAsFixed(2)} \$"),
           _buildSimpleRow("Total", "${total.toStringAsFixed(2)} \$", isBold: true),
], 
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }

  Widget _buildUsageRow(String label, String usage, double total) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(label)),
        Expanded(flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(usage),
          ),
        ),
        Expanded(flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(total.toStringAsFixed(2)),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleRow(String label, String value, {bool isBold = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.w500 : FontWeight.normal),
          ),
        ),
        const Expanded(child: SizedBox()),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.w500 : FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  String? _validateInput(String? value, double lastValue) {
    if (value == null || value.isEmpty) return "Must be filled";
    final input = double.tryParse(value);
    if (input == null) return "Invalid number";
    if (input < lastValue)
      return "Value must not be less than the previous one.";
    return null;
  }

  TextFormField _buildTextFormField({
    required String label,
    String? initialValue,
    required String suffix,
    required Function(String) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffix: Text(suffix),
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }
}
