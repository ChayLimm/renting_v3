class PriceCharge {
  final double electricityPrice;
  final double waterPrice;
  final double hygieneFee;
  final double finePerDay;
  final DateTime fineStartOn;
  final double rentsParkingPrice;
  final DateTime startDate;
  DateTime? endDate;
  PriceCharge({
    required this.electricityPrice,
    required this.waterPrice,
    required this.rentsParkingPrice,
    required this.finePerDay,
    required this.startDate,
    required this.hygieneFee,
    required this.fineStartOn,
    this.endDate,
  });

  bool isValidDate(DateTime datetime) {
    if (endDate == null) {
      // print('enddate null checked');
      return datetime.isAfter(startDate);
    }
    // print('enddate null NOT checked');
    return datetime.isAfter(startDate) && datetime.isBefore(endDate!);
  }
  
}
