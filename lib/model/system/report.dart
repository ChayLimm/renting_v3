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
  double totalParkingRent = 0;
  double totalHygienePrice = 0;

  int paidRoom = 0;

  MonthlyReport({
    required this.priceChargeList,
    required this.roomList,
    required this.forMonth,
  }) {
    for (var room in roomList) {
      for (var payment in room.paymentList) {
        if (_isPaymentForMonth(payment)) {
          paidRoom++;
          final priceCharge = _getValidPriceCharge(payment.timestamp);
          if (priceCharge == null) {
            print('Error: Invalid price charge.');
            return;
          }

          _calculateConsumptionAndPrice(payment, priceCharge);
        } else if (_isPaymentForMonth(payment) &&
            payment.status != PaymentStatus.paid) {
          notPaidRoom.add(payment);
        }
      }
    }
  }

  bool _isPaymentForMonth(Payment payment) {
    return payment.timestamp.month == forMonth.month &&
        payment.timestamp.year == forMonth.year &&
        payment.status == PaymentStatus.paid;
  }

  PriceCharge? _getValidPriceCharge(DateTime datetime) {
    priceChargeList.map((item) {
      if (item.isValidDate(datetime)) {
        return item;
      }
    });
    return null;
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
      totalParkingRent +=
          payment.tenant!.rentsParking * priceCharge.rentsParkingPrice;
    }

    totalHygienePrice += priceCharge.hygieneFee;
  }
}
