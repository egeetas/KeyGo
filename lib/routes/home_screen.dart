import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keygo_deneme/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedLocation;
  final TextEditingController _pickupDateController = TextEditingController();
  final TextEditingController _returnDateController = TextEditingController();
  int _selectedIndex = 0;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final List<String> _locations = [
    'Istanbul Airport',
    'Sabiha Gokcen Airport',
    'Ankara Esenboga Airport',
    'Antalya Airport',
    'Izmir Adnan Menderes Airport',
    'Doha Hamad International Airport',
    'Dubai International Airport',
    'London Heathrow Airport',
    'New York JFK Airport',
    'Paris Charles de Gaulle Airport',
    'Frankfurt Airport',
    'Los Angeles LAX Airport',
  ];

  @override
  void initState() {
    super.initState();
    _pickupDateController.text = _dateFormat.format(DateTime.now());
    _returnDateController.text = _dateFormat.format(
      DateTime.now().add(const Duration(days: 3)),
    );
  }

  @override
  void dispose() {
    _pickupDateController.dispose();
    _returnDateController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _selectPickupDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        _pickupDateController.text = _dateFormat.format(picked);
        final returnDate = _dateFormat.parse(_returnDateController.text);
        if (returnDate.isBefore(picked)) {
          _returnDateController.text = _dateFormat.format(
            picked.add(const Duration(days: 1)),
          );
        }
      });
    }
  }

  Future<void> _selectReturnDate() async {
    final pickupDate = _dateFormat.parse(_pickupDateController.text);
    final picked = await showDatePicker(
      context: context,
      initialDate: pickupDate.add(const Duration(days: 1)),
      firstDate: pickupDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder:
          (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.black,
                onPrimary: Colors.white,
              ),
            ),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() {
        _returnDateController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black,
                        Colors.grey.shade900,
                        Colors.black,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/home_screen_car.png',
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: -50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Image.asset(
                      'assets/keygo_logo.png',
                      width: 200,
                      height: 80,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade800,
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed:
                          () => Navigator.pushNamed(context, '/notifications'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue value) {
                      if (value.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return _locations.where(
                        (loc) => loc.toLowerCase().startsWith(
                          value.text.toLowerCase(),
                        ),
                      );
                    },
                    onSelected: (selection) {
                      _selectedLocation = selection;
                    },
                    fieldViewBuilder: (
                      context,
                      controller,
                      focusNode,
                      onSubmitted,
                    ) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          hintText: 'Pickup station',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          filled: true,
                          fillColor: Colors.grey.shade900,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) {
                          _selectedLocation = null;
                        },
                      );
                    },
                    optionsViewBuilder: (context, onSelected, options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.grey.shade900,
                          elevation: 4,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child:
                                options.isEmpty
                                    ? const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        'No matches found',
                                        style: TextStyle(color: Colors.white54),
                                      ),
                                    )
                                    : ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder: (ctx, i) {
                                        final option = options.elementAt(i);
                                        return ListTile(
                                          title: Text(
                                            option,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: "Pickup",
                          controller: _pickupDateController,
                          onTap: _selectPickupDate,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          label: "Return",
                          controller: _returnDateController,
                          onTap: _selectReturnDate,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedLocation == null) {
                          _showError('Please select a pickup station');
                          return;
                        }
                        Navigator.pushNamed(context, Routes.cars);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        'Show offers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) {
          setState(() => _selectedIndex = i);
          if (i == 1) Navigator.pushNamed(context, '/map');
          if (i == 2) Navigator.pushNamed(context, Routes.profile);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rent',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade800),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade400),
              const SizedBox(width: 6),
              Text(
                controller.text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
