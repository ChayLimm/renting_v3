import 'package:pos_renting_v3/model/stakeholder/tenant.dart';
import 'package:pos_renting_v3/model/system/pricecharge.dart';
import '../model/room/room.dart';
import '../model/stakeholder/landlord.dart';


// Create Landlord
LandLord landlord = LandLord(contact: "012321654");

// Create PriceCharge

PriceCharge newPriceCharge =

PriceCharge(
  electricityPrice: 0.5, 
  waterPrice: 0.35, 
  rentsParkingPrice: 10, 
  finePerMonth: 3, 
  startDate: DateTime(2024, 11, 11), 
  hygieneFee: 1, 
  fineStartOn: DateTime(DateTime.now().year, DateTime.now().month, 5) 
);

// Create Rooms
List<Room> roomList =
[ ];

Room room1 = Room(roomName: "A001", roomPrice: 100, landlord: landlord);
Room room2 = Room(roomName: "A002", roomPrice: 100, landlord: landlord);
Room room3 = Room(roomName: "A003", roomPrice: 110, landlord: landlord);
Room room4 = Room(roomName: "A004", roomPrice: 110, landlord: landlord);
Room room5 = Room(roomName: "A005", roomPrice: 120, landlord: landlord);
Room room6 = Room(roomName: "A006", roomPrice: 120, landlord: landlord);
// Create System instance and add data
// System system1 = System();


Tenant tenant1 = Tenant(contact: "085 165 498", identity: "013213", rentsParking: 1, deposit: 50);

// void initializeDummyData(){
//   system1.addPriceCharge(newPriceCharge);
//   system1.addRoom(room1, 100, 100);
//   system1.addRoom(room2, 100, 100);
//   system1.addRoom(room3, 100, 100);
//   system1.addRoom(room4, 100, 100);
//   system1.addRoom(room5, 100, 100);
//   system1.addRoom(room6, 100, 100);
// }

// Tenant tenant1 = Tenant(contact: "165498", identity: 13213, rentsParking: 1, deposit: 50);

// system1.manageTenant(roomlist[0], tenant1);
// system1.processPayment(room1, DateTime.now(), 200, 200);
