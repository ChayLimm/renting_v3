
import 'package:pos_renting_v3/model/payment/payment.dart';

class Consumption{

  

  final Payment lastpayment;
  final double waterMeter;
  final double electricityMeter;
  const Consumption({
    required this.lastpayment, 
    required this.waterMeter, 
    required this.electricityMeter
    });

  double getTotalConsumption() {
    
  }
}