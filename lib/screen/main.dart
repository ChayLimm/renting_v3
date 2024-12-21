import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_renting_v3/model/system/report.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import 'package:pos_renting_v3/screen/homepage/main.dart';
import 'package:pos_renting_v3/screen/priceCharge/main.dart';
import 'package:pos_renting_v3/screen/report/main.dart';
import 'package:pos_renting_v3/utils/component.dart';
import 'package:provider/provider.dart';

class AppController extends StatefulWidget {
  final System system;
  const AppController({super.key, required this.system});

  @override
  State<AppController> createState() => _AppControllerState();
}

class _AppControllerState extends State<AppController> {
  int _pageIndex = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  String date = DateFormat('dd MMMM yyyy').format(DateTime.now());
  MonthlyReport? report ;
  List<Widget>? pages ;

  void updateReport(BuildContext context, DateTime datetime) {
    final system = Provider.of<System>(context, listen: false);
    setState(() {
      report = MonthlyReport(
          priceChargeList: system.priceChargeList,
          roomList: system.roomList,
          forMonth: datetime);
      pages = [
        MyHomePage(roomList: system.roomList,),
        ReportPage(
          report: report!,
          triggerUpdate: updateReport,
        ),
        PriceChargePage(priceChargeList: system.priceChargeList)
      ];
    });
    print("rebuild report");
  }
  @override
  void initState() {
    super.initState();
    report = MonthlyReport(priceChargeList: widget.system.priceChargeList, roomList:  widget.system.roomList, forMonth: DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<System>(builder: (context, system, child) {
      pages = [
        MyHomePage(
          roomList: system.roomList,
        ),
        ReportPage(
          report: report!,
          triggerUpdate: updateReport,
        ),
        PriceChargePage(priceChargeList: system.priceChargeList)
      ];
      return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: blue,
          animationDuration: Duration(milliseconds: 300),
          items: <Widget>[
            Icon(
              Icons.home,
              size: 32,
              color: grey,
            ),
            Icon(
              Icons.summarize,
              size: 32,
              color: grey,
            ),
            Icon(
              Icons.price_change,
              size: 32,
              color: grey,
            ),
          ],
          onTap: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            date,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
        ),
        body: pages![_pageIndex],
      );
    });
  }
}
