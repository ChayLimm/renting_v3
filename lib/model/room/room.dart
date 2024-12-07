
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/stakeholder/landlord.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';

enum RoomAvailability{
  available,
  book,
  taken
}

class Room {
  String roomName; 
  double roomPrice;
  List<Payment>? paymentList;
  LandLord landlord;
  Tenant? tenant;

  Room({
    required this.roomName, 
    required this.roomPrice, 
    required this.landlord, 
    this.paymentList, 
    this.tenant, 
    });

  RoomAvailability getRoomAvailability(){
    if(tenant == null){
      return RoomAvailability.available;
    }else if(tenant != null && tenant!.deposit == roomPrice){
      return RoomAvailability.taken;
    }else {
      return RoomAvailability.book;
    }
  }

}

