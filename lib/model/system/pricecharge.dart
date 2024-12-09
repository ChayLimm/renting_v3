class PriceCharge {
  final double electricityPrice;
  final double waterPrice;
  final double hygieneFee;
  final double finePerMonth;
  final DateTime fineStartOn;
  final double rentsParkingPrice;
  final DateTime startDate;
  DateTime? endDate;
  PriceCharge({
    required this.electricityPrice,
    required this.waterPrice,
    required this.rentsParkingPrice,
    required this.finePerMonth,
    required this.startDate,
    required this.hygieneFee,
    required this.fineStartOn,
    this.endDate,
  });

  bool isValidDate(DateTime datetime) {
    if (endDate == null) {
      return datetime.isAfter(startDate);
    }
    return datetime.isAfter(startDate) && datetime.isBefore(endDate!);
  }
  
}
