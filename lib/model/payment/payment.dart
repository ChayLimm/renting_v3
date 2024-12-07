import 'package:pos_renting_v3/model/payment/consumption.dart';
import 'package:pos_renting_v3/model/room/room.dart';
import 'package:pos_renting_v3/model/stakeholder/landlord.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';

enum  PaymentStatus{
  unpaid,
  pending,
  paid,
}

class Payment {
  final PaymentStatus status = PaymentStatus.unpaid;
  final DateTime timestamp = DateTime.now();
  final Tenant tenant;
  final LandLord landlord;
  final Room room;
  final double fine;
  final double totalPrice;
  final Consumption consumption;

   Payment({
    required this.tenant, 
    required this.landlord, 
    required this.room, 
    required this.fine,
    required this.totalPrice, 
    required this.consumption
    }
  );


  void setFine(DateTime datetime){

  }

  
  PaymentStatus getPaymentStatus(){

  }
}