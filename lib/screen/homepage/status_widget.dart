import 'package:flutter/material.dart';
import 'package:pos_renting_v3/utils/component.dart';

class StatusWidget extends StatelessWidget {
  final int available;
  final int unpaid;
  final int pending;
  final int paid;
  const StatusWidget(
      {super.key,
      required this.available,
      required this.unpaid,
      required this.pending,
      required this.paid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
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
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          BuildStatusBox(
            title: "Unpaid",
            number: unpaid,
            color: red,
          ),
          BuildStatusBox(
            title: "Pending",
            number: pending,
            color: yellow,
          ),
          BuildStatusBox(
            title: "Paid",
            number: paid,
            color: green,
          )
        ],
      ),
    );
  }
}

class BuildStatusBox extends StatelessWidget {
  final String title;
  final int number;
  final Color color;
  const BuildStatusBox(
      {super.key,
      required this.title,
      required this.number,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(8)),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: color == Theme.of(context).scaffoldBackgroundColor
                        ? Colors.black
                        : Colors.white),
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
    ));
  }
}
