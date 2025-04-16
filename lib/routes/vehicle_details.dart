import 'package:flutter/material.dart';
import 'package:keygo_deneme/utils/routes.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int carId;

  const VehicleDetailsScreen({super.key, required this.carId});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  // Seçili özellikler
  bool _hasGPS = false, _hasChildSeat = false;

  // Basitleştirilmiş araç verileri
  final List<Map<String, dynamic>> _cars = [
    {
      'id': 1,
      'name': 'Fiat 500',
      'image': 'assets/images/keygo_logo.png',
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
      'image': 'assets/images/keygo_logo.png',
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
      'image': 'assets/images/keygo_logo.png',
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
      'image': 'assets/images/keygo_logo.png',
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
            // Araç görseli
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

            // İsim ve fiyat
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
                    color: Colors.blue,
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

            // Puan
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

            // Özellikler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeature(Icons.settings, car['transmission']),
                _buildFeature(Icons.people, '${car['seats']} Seats'),
                _buildFeature(Icons.local_gas_station, car['fuelType']),
              ],
            ),
            const SizedBox(height: 24),

            // Açıklama
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(car['description'], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),

            // Eklentiler
            const Text(
              'Add-ons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // GPS
            CheckboxListTile(
              title: const Text('GPS Navigation'),
              subtitle: const Text('\$8/day'),
              value: _hasGPS,
              onChanged: (value) => setState(() => _hasGPS = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Çocuk koltuğu
            CheckboxListTile(
              title: const Text('Child Seat'),
              subtitle: const Text('\$5/day'),
              value: _hasChildSeat,
              onChanged: (value) => setState(() => _hasChildSeat = value!),
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 30),

            // Rezervasyon butonu
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Reservation Complete'),
                          content: const Text(
                            'Your reservation has been confirmed!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  Routes.home,
                                  (route) => false,
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Reserve Now',
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
