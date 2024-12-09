import '../payment/consumption.dart';
import '../payment/payment.dart';
import '../stakeholder/tenant.dart';
import '../room/room.dart';
import 'pricecharge.dart';
import 'report.dart';

class System {
  List<PriceCharge> priceChargeList = [];
  List<Room> roomList = [];

  PriceCharge? getValidPriceCharge(DateTime datetime) {
    for(var item in priceChargeList){
      if(item.isValidDate(datetime)){
        return item;
      }
    }
    return null;
  }

  void processPayment(Room room, DateTime datetime, double inputWater,
      double inputElectricity) {
    // Check for a valid price charge
    PriceCharge? priceCharge = getValidPriceCharge(datetime);
    if (priceCharge == null) {
      print('Error: Invalid price charge.');
      return;
    }

    // Retrieve last payment and tenant details
    Payment? lastPayment =
        room.paymentList.isNotEmpty ? room.paymentList.last : null;
    Tenant? tenant = room.tenant;

    // Check if water and electricity meters are valid
    if (inputWater < 0 || inputElectricity < 0) {
      print("Error: Water and electricity readings must be non-negative.");
      return;
    }

    // If no previous payment or tenant, register a new room payment
    if (lastPayment == null || tenant == null) {
      Consumption consumption = Consumption(
          waterMeter: inputWater, electricityMeter: inputElectricity);
      Payment registerPayment = Payment(
        tenant: null,
        landlord: room.landlord,
        room: room,
        totalPrice: 0,
        consumption: consumption,
      );
      room.paymentList.add(registerPayment);
      return;
    }

    // If there is a tenant and previous payment, process payment for the next month
    Consumption consumption =
        Consumption(waterMeter: inputWater, electricityMeter: inputElectricity);

    if (inputWater < lastPayment.consumption.waterMeter ||
        inputElectricity < lastPayment.consumption.electricityMeter) {
      print(
          "Error: Water or electricity readings cannot be smaller than the last data.");
      return;
    }

    // Handle deposit update logic
    double roomPrice = _getRoomPriceForPayment(tenant, room);
    if (tenant.deposit < room.roomPrice) {
      tenant.deposit = roomPrice;
    }

    // Calculate the total price for the payment
    double consumptionTotal = consumption.getTotalConsumption(priceCharge);
    double rentingParkingTotal =
        tenant.rentsParking * priceCharge.rentsParkingPrice;
    double totalPrice = roomPrice + consumptionTotal + rentingParkingTotal;

    Payment registerPayment = Payment(
      status: PaymentStatus.pending,
      tenant: tenant,
      landlord: room.landlord,
      room: room,
      totalPrice: totalPrice,
      consumption: consumption,
    );

    room.paymentList.add(registerPayment);
  }

//calculate the room price considering the deposit
  double _getRoomPriceForPayment(Tenant tenant, Room room) {
    return tenant.deposit < room.roomPrice
        ? room.roomPrice + (room.roomPrice - tenant.deposit)
        : room.roomPrice;
  }

  void addRoom(Room room, double waterMeter, double electricityMeter) {
    if (roomList.any((item) => item.roomName == room.roomName)) {
      print("Room name must be unique");
      return;
    }
    roomList.add(room);
    processPayment(room, DateTime.now(), waterMeter, electricityMeter);
  }

  removeRoom(Room room) {
    roomList.remove(room);
  }

//payment list cant be update
  updateRoom(Room room, Room updateRoom) {
    for (var item in roomList) {
      if (item.roomName == room.roomName) {
        item.roomPrice = updateRoom.roomPrice;
        item.roomName = updateRoom.roomName;
        item.tenant = updateRoom.tenant;
        item.landlord = updateRoom.landlord;
        return;
      }
    }
  }

  void updatePaymentStatus(Room room, Payment payment, PaymentStatus status) {
    for (var item in roomList) {
      if (item.roomName == room.roomName) {
        for (var i = 0; i < item.paymentList.length; i++) {
          if (item.paymentList[i].timestamp == payment.timestamp) {
            item.paymentList[i].status = status; // Update the payment status
            return; // Exit once the status is updated
          }
        }
      }
    }
    print("Payment not found");
  }

  void updatePayment(Room room, Payment newpayment) {
    for (var item in roomList) {
      if (item.roomName == room.roomName) {
        for (var i = 0; i < item.paymentList.length; i++) {
          if (item.paymentList[i].timestamp == newpayment.timestamp) {
            item.paymentList[i] = newpayment; // Update the payment in the list
            return; // Exit once the payment is updated
          }
        }
      }
    }
  }

  void manageTenant(Room room, Tenant? tenant) {
    try {
      Room foundRoom = roomList.firstWhere(
          (item) => item.roomName == room.roomName,
          orElse: () => throw Exception('Room not found'));

      foundRoom.tenant = tenant;
    } catch (e) {
      print(e); // Or handle the exception as needed
    }
  }

 void addPriceCharge(PriceCharge newPriceCharge) {
  if (priceChargeList.isNotEmpty) {
    priceChargeList.last.endDate = DateTime.now();
  }

  priceChargeList.add(newPriceCharge);
}


  MonthlyReport generateReport(DateTime datetime) {
    return MonthlyReport(priceChargeList: priceChargeList, roomList: roomList, forMonth: datetime);
  }
}
