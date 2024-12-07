import 'package:pos_renting_v3/model/room/room.dart';

class MonthlyReport {
  final List<Room> roomlist;
  final DateTime forMonth;
  const MonthlyReport({
    required this.roomlist,
    required this.forMonth
     });
}