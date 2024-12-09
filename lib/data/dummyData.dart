import 'package:pos_renting_v3/model/system/pricecharge.dart';

import '../model/room/room.dart';
import '../model/stakeholder/landlord.dart';

LandLord landlord = LandLord(contact: 012321654);

PriceCharge priceCharge = PriceCharge(
  electricityPrice: 0.5, 
  waterPrice: 0.35, 
  rentsParkingPrice: 10, 
  finePerMonth: 3, 
  startDate: DateTime(11,11,2024), 
  hygieneFee: 1, 
  fineStartOn: DateTime(05,DateTime.now().month,DateTime.now().year)
  );



mixin hygieneFee {
}Room room1 =    Room(roomName: "A001", roomPrice: 100, landlord: landlord);
Room room2 =    Room(roomName: "A002", roomPrice: 100, landlord: landlord);
Room room3 =    Room(roomName: "A003", roomPrice: 110, landlord: landlord);
Room room4 =    Room(roomName: "A004", roomPrice: 110, landlord: landlord);
Room room5 =    Room(roomName: "A005", roomPrice: 120, landlord: landlord);
Room room6 =    Room(roomName: "A006", roomPrice: 120, landlord: landlord);



