import 'dart:ui';

import '../payment/consumption.dart';
import '../room/room.dart';
import '../stakeholder/landlord.dart';
import '../stakeholder/tenant.dart';
import '../system/pricecharge.dart';

enum  PaymentStatus{
  unpaid(Color(0xFFFF0000)),
  pending(Color(0xFFF8A849)),
  paid(Color(0xFF4FAC80));

  final Color color;
  const PaymentStatus(this.color);
}

class Payment {
  PaymentStatus status ;
  final DateTime timestamp = DateTime.now();
  final Tenant? tenant;
  final LandLord landlord;
  final Room room;
  double fine;
  final double totalPrice;
  final Consumption consumption;

   Payment({
    this.status= PaymentStatus.unpaid,
    required this.tenant, 
    required this.landlord, 
    required this.room, 
    this.fine = 0.00,
    required this.totalPrice, 
    required this.consumption
    }
  );


  void setFine(PriceCharge priceCharge, DateTime datetime) {
    if (datetime.isAfter(priceCharge.fineStartOn)) {
      int fineDays = datetime.difference(priceCharge.fineStartOn).inDays;

      this.fine = priceCharge.finePerMonth * fineDays;

      print('Fine calculated for $fineDays days: $fine');
    } else {
      this.fine = 0.0;
      print('No fine applied as the date is before the fine start date.');
    }
  }


  
  PaymentStatus getPaymentStatus(){
    return status;
  }
}