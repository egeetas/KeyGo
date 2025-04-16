import 'package:flutter/material.dart';
import 'package:keygo_deneme/utils/routes.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  // Basit araç verileri
  static final List<Map<String, dynamic>> cars = [
    {
      'name': 'Fiat 500',
      'image': 'assets/images/keygo_logo.png',
      'pricePerDay': 120,
      'rating': 4.5,
      'fuelType': 'Gasoline',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'name': 'Audi A3',
      'image': 'assets/images/keygo_logo.png',
      'pricePerDay': 150,
      'rating': 4.8,
      'fuelType': 'Diesel',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'name': 'BMW i4',
      'image': 'assets/images/keygo_logo.png',
      'pricePerDay': 180,
      'rating': 4.9,
      'fuelType': 'Electric',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'name': 'Bugatti Chiron',
      'image': 'assets/images/keygo_logo.png',
      'pricePerDay': 1000,
      'rating': 5.0,
      'fuelType': 'Gasoline',
      'seats': 2,
      'transmission': 'Automatic',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Cars"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cars.length,
        itemBuilder: (context, index) => _buildCarCard(context, cars[index]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Rent",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, Routes.profile);
          } else if (index == 0) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
              (route) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, Map<String, dynamic> car) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Center(
            child: Image.asset(
              'assets/images/keygo_logo.png',
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),

          // İsim ve Fiyat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                car['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '\$${car['pricePerDay']}/day',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Yıldız
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              Text(
                ' ${car['rating']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Özellikler
          Row(
            children: [
              Icon(Icons.local_gas_station, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                car['fuelType'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 24),
              Icon(Icons.people, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                '${car['seats']} Seats',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 24),
              Icon(Icons.settings, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                car['transmission'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Buton
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.vehicleDetails,
                  arguments: cars.indexOf(car) + 1,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              child: const Text(
                "Book Now",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
