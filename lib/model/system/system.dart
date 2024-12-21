import 'package:flutter/material.dart';

import '../payment/consumption.dart';
import '../payment/payment.dart';
import '../stakeholder/tenant.dart';
import '../room/room.dart';
import 'pricecharge.dart';
import 'report.dart';

class System extends ChangeNotifier  {
  List<PriceCharge> priceChargeList;
  List<Room> roomList;

System({List<PriceCharge>? priceChargeList, List<Room>? roomList})
      : priceChargeList = priceChargeList ?? [],
        roomList = roomList ?? [];

  PriceCharge getValidPriceCharge(DateTime datetime) {
    for(var item in priceChargeList){
      if(item.isValidDate(datetime)){
        return item;
      }
    }
    //fix this later
    return PriceCharge(electricityPrice: 0, waterPrice: 0, rentsParkingPrice: 0, finePerDay: 0, startDate: datetime, hygieneFee: 0, fineStartOn: datetime);
  }
  Payment? getPaymentThisMonth(Room room, [DateTime? dateTime] ){
    dateTime ??= DateTime.now();
    return  room.paymentList.isNotEmpty &&
            room.paymentList.last.timestamp.month == dateTime.month &&
            room.paymentList.last.timestamp.year == dateTime.year 
        ? room.paymentList.last
        : null;
  }

  void processPayment(Room room, DateTime datetime, double inputWater,double inputElectricity) {
    // Check for a valid price charge
    PriceCharge? priceCharge = getValidPriceCharge(datetime);
    if (priceCharge == null) {
      print('Error: Invalid price charge.');
      return;
    }

    // Retrieve last payment and tenant details
    Payment? lastPayment = room.paymentList.isNotEmpty ? room.paymentList.last : null;
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
    Consumption(waterMeter: inputWater, 
    electricityMeter: inputElectricity,
    lastpayment: room.paymentList.last
    );

    if (inputWater < lastPayment.consumption.waterMeter ||
        inputElectricity < lastPayment.consumption.electricityMeter) {
      print(
          "Error: Water or electricity readings cannot be smaller than the last data.");
      return;
    }

    double roomPrice = room.roomPrice;
    double deposit =  getDepositPrice(room);


    // Calculate the total price for the payment
    double consumptionTotal = consumption.getTotalConsumption(priceCharge);
    double rentingParkingTotal =
        tenant.rentsParking * priceCharge.rentsParkingPrice;
    double totalPrice = roomPrice + consumptionTotal + rentingParkingTotal+ deposit;

    Payment registerPayment = Payment(
      status: PaymentStatus.pending,
      tenant: tenant,
      landlord: room.landlord,
      room: room,
      totalPrice: totalPrice,
      consumption: consumption,
      deposit: deposit
    );

    room.paymentList.add(registerPayment);
    notifyListeners();
  }

//calculate the room price considering the deposit
  double getDepositPrice(Room room) {
    return room.tenant!.deposit < room.roomPrice
        ? room.roomPrice - room.tenant!.deposit
        : 0;
  }
  bool roomIsExist(String roomName){
    if (roomList.any((item) => item.roomName == roomName)) {
      print("Room name must be unique");
      return true;
    }
    return false;
  }

  void addRoom(Room room, double waterMeter, double electricityMeter,[ Tenant? tenant]) {
    if(roomIsExist(room.roomName)){
      print("room must be unique");
      return;
    }
    roomList.add(room);
    processPayment(room, DateTime.now(), waterMeter, electricityMeter);
    if(tenant != null){
      manageTenant(room, tenant);
    }
     notifyListeners();
  }

  void removeRoom(Room room) {
    roomList.remove(room);
     notifyListeners();
  }

//payment list cant be update
  updateRoom(Room updateRoom) {
    for (var item in roomList) {
      if (item.id == updateRoom.id) {
        item.roomPrice = updateRoom.roomPrice;
        item.roomName = updateRoom.roomName;
        item.tenant = updateRoom.tenant;
        item.landlord = updateRoom.landlord;
        return;
      }
    }
    notifyListeners();
  }

  void updatePaymentStatus(Room room, Payment payment, PaymentStatus status) {
    for (var item in roomList) {
      if (item.id == room.id) {
        for (var i = 0; i < item.paymentList.length; i++) {
          if (item.paymentList[i].timestamp == payment.timestamp) {
            item.paymentList[i].status = status;
            if(status == PaymentStatus.paid){
              if (room.tenant!.deposit < room.roomPrice) {
                  room.tenant!.deposit = room.roomPrice;
                }
            }
             print("Is uppdate paymend");
             notifyListeners();
            return;
          }
        }
      }
    }
    print("Payment not found");
    notifyListeners();
  }

  void setFine(Payment payment, DateTime payOn){
    PriceCharge priceCharge = getValidPriceCharge(payOn);
    if(payOn.isAfter(priceCharge.fineStartOn)){
      final dayToCharge = payOn.difference(priceCharge.fineStartOn).inDays;
      payment.fine = dayToCharge * priceCharge.finePerDay;
      return;
    }else{
      print("Paid on time");
      return;
    }
  }

  void updatePayment(Room room, Payment newpayment) {
    for (var item in roomList) {
      if (item.id == room.id) {
        for (var i = 0; i < item.paymentList.length; i++) {
          if (item.paymentList[i].timestamp == newpayment.timestamp) {
            item.paymentList[i] = newpayment; // Update the payment in the list
             notifyListeners();
            return; // Exit once the payment is updated
          }
        }
      }
    }
  }

  void manageTenant(Room room, Tenant? tenant) {
    try {
      Room foundRoom = roomList.firstWhere(
          (item) => item.id == room.id,
          orElse: () => throw Exception('Room not found'));

      foundRoom.tenant = tenant;
    } catch (e) {
      print(e); // Or handle the exception as needed
    }
    notifyListeners();
  }

 void addPriceCharge(PriceCharge newPriceCharge) {
  if (priceChargeList.isNotEmpty) {
    priceChargeList.last.endDate = DateTime.now();
  }

  priceChargeList.add(newPriceCharge);
   notifyListeners();
}


  MonthlyReport generateReport(DateTime datetime) {
    return MonthlyReport(priceChargeList: priceChargeList, roomList: roomList, forMonth: datetime);
  }
}
