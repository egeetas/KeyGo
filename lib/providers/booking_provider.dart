import 'package:flutter/material.dart';

class BookingProvider with ChangeNotifier {
  String? pickupLocation;
  DateTime? pickupDate;
  DateTime? returnDate;

  String? carName;
  double? carPrice;
  String? imagePath;

  String? insurancePlan;

  void setLocation(String location) {
    pickupLocation = location;
    notifyListeners();
  }

  void setDates(DateTime pickup, DateTime returnD) {
    pickupDate = pickup;
    returnDate = returnD;
    notifyListeners();
  }

  void setCarDetails(String name, double price, String image) {
    carName = name;
    carPrice = price;
    imagePath = image;
    notifyListeners();
  }

  void setInsurance(String plan) {
    insurancePlan = plan;
    notifyListeners();
  }

  int get dayCount {
    if (pickupDate != null && returnDate != null) {
      return returnDate!.difference(pickupDate!).inDays;
    }
    return 1;
  }

  void reset() {
    pickupLocation = null;
    pickupDate = null;
    returnDate = null;
    carName = null;
    carPrice = null;
    imagePath = null;
    insurancePlan = null;
    notifyListeners();
  }
}
