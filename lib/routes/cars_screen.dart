import 'package:flutter/material.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({super.key});

  static final List<Map<String, dynamic>> cars = [
    {
      'id': 1,
      'name': 'Fiat 500',
      'image': 'assets/keygo_logo.png',
      'imagePath': 'assets/500e.png',
      'pricePerDay': 120,
      'rating': 4.5,
      'fuelType': 'Gasoline',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'id': 2,
      'name': 'Audi A3',
      'image': 'assets/keygo_logo.png',
      'imagePath': 'assets/audi.png',
      'pricePerDay': 150,
      'rating': 4.8,
      'fuelType': 'Diesel',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'id': 3,
      'name': 'BMW i4',
      'image': 'assets/keygo_logo.png',
      'imagePath': 'assets/bmw.png',
      'pricePerDay': 180,
      'rating': 4.9,
      'fuelType': 'Electric',
      'seats': 5,
      'transmission': 'Automatic',
    },
    {
      'id': 4,
      'name': 'Bugatti Chiron',
      'image': 'assets/keygo_logo.png',
      'imagePath': 'assets/bugatti.png',
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
          Center(
            child: Image.asset(
              car['imagePath'],
              height: 160,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),
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
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              Text(
                ' ${car['rating']}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.local_gas_station,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                car['fuelType'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.people, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                '${car['seats']} Seats',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.settings, color: Colors.white, size: 18),
              const SizedBox(width: 5),
              Text(
                car['transmission'],
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/vehicleDetails',
                  arguments: car['id'],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white, width: 0.5),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Book Now"),
            ),
          ),
        ],
      ),
    );
  }
}
