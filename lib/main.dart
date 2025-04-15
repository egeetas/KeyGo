import 'package:flutter/material.dart';
import 'pages/rental_car_list.dart'; // ← Sayfanı buradan çağırıyorsun

void main() {
  runApp(CarRentalApp());
}

class CarRentalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rental App',
      theme: ThemeData.dark(),
      home: RentalCarList(), // ← İlk açılacak sayfa
    );
  }
}
