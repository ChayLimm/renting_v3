import '../payment/consumption.dart';
import '../room/room.dart';
import '../stakeholder/landlord.dart';
import '../stakeholder/tenant.dart';
import '../system/pricecharge.dart';

enum  PaymentStatus{
  unpaid,
  pending,
  paid,
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