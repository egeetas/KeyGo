import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/booking_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Map App',
      theme: ThemeData.dark(),
      home: HomeController(),
    );
  }
}

class HomeController extends StatefulWidget {
  const HomeController({super.key});

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _selectedIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [LongTermRentScreen(), CarMapScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_filled),
            label: 'Long-term',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CarMapScreen extends StatefulWidget {
  const CarMapScreen({super.key});

  @override
  _CarMapScreenState createState() => _CarMapScreenState();
}

class _CarMapScreenState extends State<CarMapScreen> {
  final PanelController _panelController = PanelController();
  final MapController _mapController = MapController();

  final LatLng sabanciUni = LatLng(40.8910, 29.3776);

  List<Map<String, dynamic>> carLocations = [];
  String selectedCarName = '';
  String selectedCarPrice = '';
  String selectedCarImage = '';

  LatLng currentCenter = LatLng(40.8910, 29.3776);
  double currentZoom = 16;

  @override
  void initState() {
    super.initState();
    _generateCarLocations();
  }

  void _generateCarLocations() {
    carLocations.clear();
    final random = Random();
    final carGroups = ['500e', 'audi', 'bmw'];

    for (int i = 0; i < 50; i++) {
      final double latOffset = (random.nextDouble() - 0.5) * 0.45;
      final double lngOffset = (random.nextDouble() - 0.5) * 0.45;
      final carGroup = carGroups[min(i ~/ 15, carGroups.length - 1)];

      carLocations.add({
        'name': carGroup,
        'position': LatLng(
          sabanciUni.latitude + latOffset,
          sabanciUni.longitude + lngOffset,
        ),
        'price': '${100 + random.nextInt(50)}₺/hr',
        'image': 'assets/$carGroup.png',
      });
    }
  }

  Future<void> _goToLocation(String query) async {
    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final target = LatLng(locations[0].latitude, locations[0].longitude);
        setState(() {
          currentCenter = target;
          currentZoom = 16;
        });
        _mapController.move(target, 16);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Location not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search for a location...',
            hintStyle: TextStyle(color: Colors.white54),
            prefixIcon: Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (query) => _goToLocation(query),
        ),
      ),
      body: Stack(
        children: [
          SlidingUpPanel(
            controller: _panelController,
            minHeight: 0,
            maxHeight: 300,
            panel: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (selectedCarImage.isNotEmpty)
                            Image.asset(
                              selectedCarImage,
                              height: 100,
                              width: 100,
                              fit: BoxFit.contain,
                            ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedCarName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Price: $selectedCarPrice',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Details:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '- Model: ${selectedCarName.split(' ').last} Series',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '- Availability: Available for rent',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '- Terms: Minimum rental duration is 1 hour',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ElevatedButton(
                      onPressed: () {
                        final booking = Provider.of<BookingProvider>(
                          context,
                          listen: false,
                        );

                        booking.setCarDetails(
                          selectedCarName,
                          double.tryParse(
                                selectedCarPrice.replaceAll(
                                  RegExp(r'[^\d.]'),
                                  '',
                                ),
                              ) ??
                              0,
                          selectedCarImage,
                        );

                        Navigator.pushNamed(context, '/insurance');
                      },
                      child: Text('Rent Now'),
                    ),
                  ),
                ],
              ),
            ),
            body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: sabanciUni,
                initialZoom: 16,
                onTap: (tapPosition, point) => _panelController.close(),
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    currentCenter = position.center;
                    currentZoom = position.zoom;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers:
                      carLocations.map((car) {
                        return Marker(
                          width: 40,
                          height: 40,
                          point: car['position'],
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCarName = car['name'];
                                selectedCarPrice = car['price'];
                                selectedCarImage = car['image'];
                              });
                              _panelController.open();
                            },
                            child: Icon(
                              Icons.location_on,
                              color: Colors.cyan,
                              size: 40,
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  onPressed: () {
                    final newZoom = currentZoom + 1;
                    _mapController.move(currentCenter, newZoom);
                    setState(() => currentZoom = newZoom);
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.add),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  onPressed: () {
                    final newZoom = currentZoom - 1;
                    _mapController.move(currentCenter, newZoom);
                    setState(() => currentZoom = newZoom);
                  },
                  backgroundColor: Colors.black,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LongTermRentScreen extends StatelessWidget {
  const LongTermRentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Long-term Rentals', style: TextStyle(fontSize: 22)),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('User Profile', style: TextStyle(fontSize: 22)));
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CarMapScreen();
  }
}
