
import 'package:uuid/uuid.dart';

import '../payment/payment.dart';
import '../stakeholder/landlord.dart';
import '../stakeholder/tenant.dart';



enum RoomAvailability{
  available,
  book,
  taken
}

class Room {
  final String? id;
  String roomName; 
  double roomPrice;
  List<Payment> paymentList = [ ];
  LandLord landlord;
  Tenant? tenant;

    Room({
    required this.roomName, 
    required this.roomPrice, 
    required this.landlord, 
    String? id, 
    this.tenant,
  }) : id = id ?? const Uuid().v4();

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

