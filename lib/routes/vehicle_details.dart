import 'package:flutter/material.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int carId;

  const VehicleDetailsScreen({super.key, required this.carId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  bool _hasGPS = false, _hasChildSeat = false;

  final List<Map<String, dynamic>> _cars = [
    {
      'id': 1,
      'name': 'Fiat 500',
      'image': 'assets/500e.png',
      'imagePath': 'assets/500e.png',
      'pricePerDay': 120,
      'rating': 4.5,
      'fuelType': 'Gasoline',
      'seats': 5,
      'transmission': 'Automatic',
      'description': 'Compact city car with excellent fuel economy.',
    },
    {
      'id': 2,
      'name': 'Audi A3',
      'image': 'assets/audi.png',
      'imagePath': 'assets/audi.png',
      'pricePerDay': 150,
      'rating': 4.8,
      'fuelType': 'Diesel',
      'seats': 5,
      'transmission': 'Automatic',
      'description': 'Premium compact sedan with advanced technology.',
    },
    {
      'id': 3,
      'name': 'BMW i4',
      'image': 'assets/bmw.png',
      'imagePath': 'assets/bmw.png',
      'pricePerDay': 180,
      'rating': 4.9,
      'fuelType': 'Electric',
      'seats': 5,
      'transmission': 'Automatic',
      'description': 'All-electric sedan with impressive range.',
    },
    {
      'id': 4,
      'name': 'Bugatti Chiron',
      'image': 'assets/bugatti.png',
      'imagePath': 'assets/bugatti.png',
      'pricePerDay': 1000,
      'rating': 5.0,
      'fuelType': 'Gasoline',
      'seats': 2,
      'transmission': 'Automatic',
      'description': 'Ultimate hypercar with breathtaking performance.',
    },
  ];

  Map<String, dynamic> _getCar() => _cars.firstWhere(
    (car) => car['id'] == widget.carId,
    orElse: () => _cars[0],
  );

  @override
  Widget build(BuildContext context) {
    final car = _getCar();

    return Scaffold(
      appBar: AppBar(
        title: Text(car['name']),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                car['image'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
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
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '\$${car['pricePerDay']}/day',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  ' ${car['rating']}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(Icons.settings, car['transmission']),
                _buildFeature(Icons.people, '${car['seats']} Seats'),
                _buildFeature(Icons.local_gas_station, car['fuelType']),
              ],
            ),
            const SizedBox(height: 24),

            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(car['description'], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),

            const Text(
              'Add-ons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            CheckboxListTile(
              title: const Text('GPS Navigation'),
              subtitle: const Text('\$8/day'),
              value: _hasGPS,
              onChanged: (value) => setState(() => _hasGPS = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            CheckboxListTile(
              title: const Text('Child Seat'),
              subtitle: const Text('\$5/day'),
              value: _hasChildSeat,
              onChanged: (value) => setState(() => _hasChildSeat = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/insurance',
                    arguments: {
                      'carName': car['name'],
                      'carPrice': car['pricePerDay'].toString(),
                      'carImagePath': car['imagePath'],
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Continue to Insurance',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Column(
      children: [Icon(icon, size: 30), const SizedBox(height: 6), Text(text)],
    );
  }
}
