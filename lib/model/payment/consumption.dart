import '../payment/payment.dart';
import '../system/pricecharge.dart';

class Consumption {
  final Payment? lastpayment;
  final double waterMeter;
  final double electricityMeter;

  Consumption({
    this.lastpayment,
    required this.waterMeter,
    required this.electricityMeter,
  });

  double getTotalConsumption(PriceCharge pricecharge) {
    if (lastpayment == null) {
      return _calculateConsumption(
        waterUsed: waterMeter,
        electricityUsed: electricityMeter,
        pricecharge: pricecharge,
      );
    }

    double waterUsed = waterMeter - lastpayment!.consumption.waterMeter;
    double electricityUsed = electricityMeter - lastpayment!.consumption.electricityMeter;

    return _calculateConsumption(
      waterUsed: waterUsed,
      electricityUsed: electricityUsed,
      pricecharge: pricecharge,
    );
  }

  double _calculateConsumption({
    required double waterUsed,
    required double electricityUsed,
    required PriceCharge pricecharge,
  }) {
    double waterConsumptionTotal = waterUsed * pricecharge.waterPrice;
    double electricityConsumptionTotal =
        electricityUsed * pricecharge.electricityPrice;
    double hygieneConsumptionTotal = pricecharge.hygieneFee;

    return waterConsumptionTotal +
        electricityConsumptionTotal +
        hygieneConsumptionTotal;
  }
}
