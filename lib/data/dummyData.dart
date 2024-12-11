import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import 'package:pos_renting_v3/model/system/system.dart';
import '../model/room/room.dart';
import '../model/stakeholder/landlord.dart';


// Create Landlord
LandLord landlord = LandLord(contact: "012321654");

// Create PriceCharge

List<PriceCharge> priceCharge =

[PriceCharge(
  electricityPrice: 0.5, 
  waterPrice: 0.35, 
  rentsParkingPrice: 10, 
  finePerMonth: 3, 
  startDate: DateTime(2024, 11, 11), // Corrected date
  hygieneFee: 1, 
  fineStartOn: DateTime(DateTime.now().year, DateTime.now().month, 5) // Corrected date
)];

// Create Rooms
List<Room> roomList =
[ Room(roomName: "A001", roomPrice: 100, landlord: landlord),
 Room(roomName: "A002", roomPrice: 100, landlord: landlord),
 Room(roomName: "A003", roomPrice: 110, landlord: landlord),
 Room(roomName: "A004", roomPrice: 110, landlord: landlord),
 Room(roomName: "A005", roomPrice: 120, landlord: landlord),
 Room(roomName: "A006", roomPrice: 120, landlord: landlord),];

// Create System instance and add data
System system1 = System(roomList: roomList,priceChargeList: priceCharge);


Tenant tenant1 = Tenant(contact: "165498", identity: 13213, rentsParking: 1, deposit: 50);

// Tenant tenant1 = Tenant(contact: "165498", identity: 13213, rentsParking: 1, deposit: 50);

// system1.manageTenant(roomlist[0], tenant1);
// system1.processPayment(room1, DateTime.now(), 200, 200);