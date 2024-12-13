import 'package:flutter/material.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/utils/component.dart';

class StatusWidget extends StatelessWidget {
  final int available;
  final int unpaid;
  final int pending;
  final int paid;
  final Function(PaymentStatus?) selectedGroupBy;
  const StatusWidget(
      {super.key,
      required this.available,
      required this.unpaid,
      required this.pending,
      required this.paid,
      required this.selectedGroupBy
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [shadow()]),
      child: Row(
        children: [
          BuildStatusBox(
            title: "Available",
            number: available,
            selectedGroupBy : selectedGroupBy,
            status: null
          ),
          BuildStatusBox(
            title: "Unpaid",
            number: unpaid,
            selectedGroupBy : selectedGroupBy,
            status: PaymentStatus.unpaid
          ),
          BuildStatusBox(
            title: "Pending",
            number: pending,
            selectedGroupBy : selectedGroupBy,
            status: PaymentStatus.pending
          ),
          BuildStatusBox(
            title: "Paid",
            number: paid,
            selectedGroupBy : selectedGroupBy,
            status: PaymentStatus.paid
          )
        ],
      ),
    );
  }
}

class BuildStatusBox extends StatelessWidget {
  final String title;
  final int number;
  final PaymentStatus? status;
  final Function(PaymentStatus?) selectedGroupBy;

  const BuildStatusBox(
      {super.key,
      required this.title,
      required this.number,
      required this.status,
      required this.selectedGroupBy
      });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
          onTap: ()=> selectedGroupBy(status),
          child: Container(
                padding: const EdgeInsets.all(4),
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                  color: status == null ? Colors.grey : status?.color, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: Text(
                  number.toString(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color:Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            )
          ],
                ),
              ),
        ));
  }
}
