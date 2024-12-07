import 'package:pos_renting_v3/model/payment/consumption.dart';
import 'package:pos_renting_v3/model/payment/payment.dart';
import 'package:pos_renting_v3/model/stakeholder/tenant.dart';

import 'chargePrice.dart';
import '../room/room.dart';

class System{
  List<Chargeprice> chargePriceList = [];
  List<Room> roomList = [];

  Chargeprice? getChargePrice(DateTime datetime){
    chargePriceList.map((item){
      if(item.isValidDate(datetime)){
        return item;
      }
     }
    );
    return null;
  }
  
  processPayment(Room room, double inputWater, double inputElectricity){
    Payment lastPayment = room.
    Consumption(lastpayment: lastpayment, waterMeter: waterMeter, electricityMeter: electricityMeter)
  }
  
  addRoom(Room room){

  }
  removeRoom(Room room){

  }
  updateRoom(Room room, Room updateRoom){

  }
  Payment? getLastPayment(Room room){
    if(room.paymentList != null){
          return room.paymentList.last;
    }
    return null;
  }
  void updatePaymentStatus(PaymentStatus status){

  }
  void updatePayment(){

  }
  

  manageTenant(Room room,Tenant tenant){
    
  }
  generateReport(DateTime datetime){

  }


}