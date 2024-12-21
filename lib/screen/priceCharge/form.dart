import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class PriceForm extends StatefulWidget {
  final Function(BuildContext, PriceCharge) triggerAdd;
  const PriceForm({super.key, required this.triggerAdd});

  @override
  State<PriceForm> createState() => _PriceFormState();
}

class _PriceFormState extends State<PriceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double newWater = 0;
  double newElectricity = 0;
  double newRentParking = 0;
  double newHygiene = 0;
  double newFine = 0;
  DateTime? newFineStart = DateTime(DateTime.now().year, DateTime.now().month, 5);
  String? formattedDate;

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, 5);

  @override
  void initState() {
    formattedDate = DateFormat('dd/MM/yyyy').format(date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
         final  system = Provider.of<System>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(_formKey.currentState!.validate()){
            PriceCharge newPriceCharge = PriceCharge(
            electricityPrice: newElectricity, 
            waterPrice: newWater, 
            rentsParkingPrice: newRentParking, 
            finePerDay: newFine, 
            startDate: DateTime.now(), 
            hygieneFee: newHygiene, 
            fineStartOn: newFineStart!);
            
            system.addPriceCharge(newPriceCharge);
            showCustomSnackBar(context, "Added Price charge successfully", green);
            Navigator.pop(context);
          }else{
            showCustomSnackBar(context, "Error : can not add", red);
          }
        },
        label: const Text("Submit",style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add,color: Colors.white,),
        backgroundColor: blue,

        ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Price Charge"),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 700,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  label("Price Charge"),
                  IconButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              const Divider(
                thickness: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildTextFormField(
                      keyboardType: TextInputType.number,
                      suffix: "\$",
                      label: "Electricity",
                      onChanged: (value) => setState(() {
                        newElectricity = double.parse(value);
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Must fill" : null,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: buildTextFormField(
                      keyboardType: TextInputType.number,
                      suffix: "\$",
                      label: "Water",
                      onChanged: (value) => setState(() {
                        newWater = double.parse(value);
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Must fill" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: buildTextFormField(
                      keyboardType: TextInputType.number,
                      suffix: "\$",
                      label: "Parking",
                      onChanged: (value) => setState(() {
                        newRentParking = double.parse(value);
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Must fill" : null,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: buildTextFormField(
                      keyboardType: TextInputType.number,
                      suffix: "\$",
                      label: "Hygiene",
                      onChanged: (value) => setState(() {
                        newHygiene = double.parse(value);
                      }),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Must fill" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              buildTextFormField(
                keyboardType: TextInputType.number,
                suffix: "\$",
                label: "Fine",
                onChanged: (value) => setState(() {
                  newFine = double.parse(value);
                }),
                validator: (value) =>
                    value == null || value.isEmpty ? "Must fill" : null,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Start charging after :"),
                  GestureDetector(
                      onTap: () {
                        setState(() async {
                          final DateTime? pickedDate =
                              await selectDate(context);
                          if (pickedDate != null &&
                              pickedDate != newFineStart) {
                            setState(() {
                              newFineStart = pickedDate;
                              formattedDate = DateFormat('dd/MM/yyyy')
                                  .format(newFineStart!);
                            });
                          }
                        });
                      },
                      child: Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(formattedDate!),
                            const Icon(Icons.date_range)
                          ],
                        ),
                      )),
                ],
              ),
               Container(
                 margin: const EdgeInsets.symmetric(vertical: 10),
                 child: const Divider(
                  thickness: 1,
                               ),
               ),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'NOTE : ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: red,
                            fontSize: 12)),
                    const TextSpan(
                        text: 'new price charge will be use after added',
                        style: TextStyle(fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
