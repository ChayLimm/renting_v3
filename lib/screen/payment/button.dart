import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/payment/main.dart';
import 'package:pos_renting_v3/screen/receipt/receipt.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class PaymentButton extends StatelessWidget {
  final Room room;
  const PaymentButton({super.key, required this.room});
  void routeToPaymentPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaymentPage(
                  room: room,
                )));
  }

  void updateStatus(
      BuildContext context, System system, Payment thisMonthPayment) async {
    bool isAgree = await showAgreementDialog(
        context, "Are you sure", 'Room ${room.roomName} has paid?');
    if (isAgree) {
      system.updatePaymentStatus(room, thisMonthPayment, PaymentStatus.paid);
      showCustomSnackBar(context, "Approved!", green);
      Navigator.pop(context);
    } else {
      showCustomSnackBar(context, "Rejected!", red);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<System>(context);
    final Payment? thisMonthPayment = system.getPaymentThisMonth(room);
    final PriceCharge priceCharge =
        system.getValidPriceCharge(thisMonthPayment!.timestamp);

    late String title;
    late PaymentStatus status;
    late VoidCallback trigger;
    bool isFine = false;
    DateTime? timestamp = DateTime.now();
    int overdueDate = 0;

    if (timestamp.isAfter(priceCharge.fineStartOn)) {
      overdueDate = timestamp.difference(priceCharge.fineStartOn).inDays;
    }

    if (thisMonthPayment == null) {
      status = PaymentStatus.unpaid;
    } else {
      status = thisMonthPayment.status;
    }

    switch (status) {
      case PaymentStatus.unpaid:
        title = "Pay Now";
        trigger = () =>
            routeToPaymentPage(context); // Correct: call the function here
        break;
      case PaymentStatus.pending:
        title = "Mark as Paid";
        trigger = () => showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              label("Mark as Paid", color: blue),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close))
                            ],
                          ),
                          divider(),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text("Pay on : "),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final newtimestamp = await selectDate(context);
                              late int newOverdueDate;
                              if (newtimestamp!
                                  .isAfter(priceCharge.fineStartOn)) {
                                newOverdueDate = newtimestamp
                                    .difference(priceCharge.fineStartOn)
                                    .inDays;
                              } else {
                                newOverdueDate = 0;
                              }
                              setState(() {
                                if (newtimestamp == null) {
                                  timestamp = DateTime.now();
                                } else {
                                  timestamp = newtimestamp;
                                }
                                overdueDate = newOverdueDate;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1, color: grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateFormat('dd MMMM yyyy')
                                        .format(timestamp!)),
                                    const Icon(Icons.date_range),
                                  ]),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text("Set Fine :"),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isFine = !isFine!;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: isFine! ? blue : grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Charge Penalty"),
                                  Checkbox(
                                      activeColor: blue,
                                      value: isFine,
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            isFine = value;
                                          });
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                          if (isFine) ...[
                            divider(10),
                            buildDetailRow(
                                "OverdueDays : ", "${overdueDate} days"),
                            buildDetailRow("Fine : ",
                                "${overdueDate * priceCharge.finePerDay} \$"),
                          ]
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          system.updatePaymentStatus(
                              room, thisMonthPayment!, PaymentStatus.paid);
                          if (isFine) {
                            system.setFine(thisMonthPayment, timestamp!);
                          }
                          showCustomSnackBar(
                              context, "${room.roomName} Has paid", green);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
            });
        break;
      case PaymentStatus.paid:
        title = "Receipt";
        trigger = () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ReceiptPage(
                        payment: room.paymentList.last,
                      )));
        };
        break;
    }

    return FloatingActionButton.extended(
      onPressed:
          trigger, // Correct: trigger is now a function reference to be called
      label: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: status.color,
    );
  }
}
