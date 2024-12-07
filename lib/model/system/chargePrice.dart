class Chargeprice {
  final double electricityPrice;
  final double waterPrice;
  final double finePerMonth;
  final double rentsParkingPrice;
  final DateTime startDate;
  DateTime? endDate;
  Chargeprice({
    required this.electricityPrice,
    required this.waterPrice,
    required this.rentsParkingPrice,
    required this.finePerMonth,
    required this.startDate,
    this.endDate,
  });

  bool isValidDate(DateTime datetime) {
    if (endDate == null) {
      return datetime.isAfter(startDate);
    }
    return datetime.isAfter(startDate) && datetime.isBefore(endDate!);
  }
  
}
