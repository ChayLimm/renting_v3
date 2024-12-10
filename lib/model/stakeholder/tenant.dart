class Tenant {
  int identity;
  String contact;
  double deposit;
  int rentsParking;

  Tenant(
      {required this.identity,
      required this.contact,
      this.deposit = 0,
      this.rentsParking = 0});
}
