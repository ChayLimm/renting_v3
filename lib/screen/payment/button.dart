import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/payment/main.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class PaymentButton extends StatelessWidget {
  final Room room;
  const PaymentButton({super.key, required this.room});

  


  void routeToPaymentPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage(room: room,)));

  }

  void updateStatus(BuildContext context,System system, Payment lastPayment) async {
    bool isAgree = await showAgreementDialog(context,"Are you sure",'Room ${room.roomName} has paid?');
    if(isAgree){
    system.updatePaymentStatus(room, lastPayment, PaymentStatus.paid);
      showCustomSnackBar(context,"Approved!",green);
    Navigator.pop(context);
    }else {
      showCustomSnackBar(context,"Rejected!",red);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final system = Provider.of<System>(context);
    final Payment? lastPayment = system.getPaymentThisMonth(room);

    late String title;
    late PaymentStatus status;
    late VoidCallback trigger;

    if (lastPayment == null) {
      status = PaymentStatus.unpaid;
    } else {
      status = lastPayment.status;
    }

    switch (status) {
      case PaymentStatus.unpaid:
        title = "Pay Now";
        trigger = () => routeToPaymentPage(context);  // Correct: call the function here
        break;
      case PaymentStatus.pending:
        title = "Mark as Paid";
        trigger = () => updateStatus(context,system, lastPayment!);  // Correct: call the function here
        break;
      case PaymentStatus.paid:
        title = "Receipt";
        trigger = () {
          print("Do something");
          // Check receipt or turn back to pending
        };
        break;
    }

    return FloatingActionButton.extended(
      onPressed: trigger,  // Correct: trigger is now a function reference to be called
      label: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: status.color,
    );
  }
}
