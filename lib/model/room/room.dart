
import '../payment/payment.dart';
import '../stakeholder/landlord.dart';
import '../stakeholder/tenant.dart';


enum RoomAvailability{
  available,
  book,
  taken
}

class Room {
  String roomName; 
  double roomPrice;
  List<Payment> paymentList = [ ];
  LandLord landlord;
  Tenant? tenant;

  Room({
    required this.roomName, 
    required this.roomPrice, 
    required this.landlord, 
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

