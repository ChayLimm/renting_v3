import 'package:pos_renting_v3/model/system/system.dart';
import 'package:provider/provider.dart';

import '../payment/payment.dart';
import '../room/room.dart';
import 'pricecharge.dart';

class MonthlyReport {
  final List<PriceCharge> priceChargeList;
  final List<Room> roomList;
  final DateTime forMonth;

  List<Payment> notPaidRoom = [];
  double totalElectricityConsumption = 0;
  double totalWaterConsumption = 0;

  double totalElectricityPrice = 0;
  double totalWaterPrice = 0;
  double totalParkingRentPrice = 0;
  double totalHygienePrice = 0;
  double totalRoomPrice = 0;

  int paidRoom = 0;
  int totalParking = 0;

  double overallPrice = 0 ;

  MonthlyReport({
    required this.priceChargeList,
    required this.roomList,
    required this.forMonth,
  }) {
    for (var room in roomList) {
      for (var payment in room.paymentList) {
        if (_isPaymentForMonth(payment)) {
          paidRoom++;
          totalRoomPrice += room.roomPrice;
          totalParking += room.tenant!.rentsParking;
          final priceCharge = getValidPriceCharge(payment.timestamp);
          if (priceCharge == null) {
            print('Error: Invalid price charge.');
            return;
          }
          _calculateConsumptionAndPrice(payment, priceCharge);
        }
      }
    }
     overallPrice = totalElectricityPrice+totalWaterPrice+totalParkingRentPrice+totalParkingRentPrice+totalRoomPrice;

  }
   PriceCharge? getValidPriceCharge(DateTime datetime) {
    for(var item in priceChargeList){
      if(item.isValidDate(datetime)){
        return item;
      }
    }
    print("invalid price charge");
    //fix this later
    return null;
  }

  bool _isPaymentForMonth(Payment payment) {
    return payment.timestamp.month == forMonth.month &&
        payment.timestamp.year == forMonth.year &&
        payment.status == PaymentStatus.paid;
  }


  void _calculateConsumptionAndPrice(Payment payment, PriceCharge priceCharge) {
    final electricityUsage = payment.consumption.lastpayment != null
        ? payment.consumption.electricityMeter -
            payment.consumption.lastpayment!.consumption.electricityMeter
        : 0;

    final waterUsage = payment.consumption.lastpayment != null
        ? payment.consumption.waterMeter -
            payment.consumption.lastpayment!.consumption.waterMeter
        : 0;

    totalElectricityConsumption += electricityUsage;
    totalWaterConsumption += waterUsage;

    totalElectricityPrice += electricityUsage * priceCharge.electricityPrice;
    totalWaterPrice += waterUsage * priceCharge.waterPrice;

    if (payment.tenant != null) {
      totalParkingRentPrice +=
          payment.tenant!.rentsParking * priceCharge.rentsParkingPrice;
    }

    totalHygienePrice += priceCharge.hygieneFee;
  }
//   void printReportDetails() {
//   print('--- Monthly Report Details ---');
//   print('For Month: ${forMonth.month}/${forMonth.year}');
//   print('Paid Rooms: $paidRoom');
//   print('Not Paid Rooms Count: ${notPaidRoom.length}');

//   print('Total Electricity Consumption: $totalElectricityConsumption');
//   print('Total Water Consumption: $totalWaterConsumption');
//   print('Total Electricity Price: \$${totalElectricityPrice.toStringAsFixed(2)}');
//   print('Total Water Price: \$${totalWaterPrice.toStringAsFixed(2)}');

//   print('Total Parking Rent: \$${totalParkingRent.toStringAsFixed(2)}');
//   print('Total Hygiene Price: \$${totalHygienePrice.toStringAsFixed(2)}');

//   print('Rooms Not Paid:');
//   for (var payment in notPaidRoom) {
//     print(' - Room ID: ${payment.room.roomName}, Status: ${payment.status}');
//   }
//   print('-------------------------------');
// }

}
