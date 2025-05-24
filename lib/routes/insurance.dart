import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/booking_provider.dart';

class InsuranceSelectionPage extends StatefulWidget {
  const InsuranceSelectionPage({super.key});

  @override
  State<InsuranceSelectionPage> createState() => _InsuranceSelectionPageState();
}

class _InsuranceSelectionPageState extends State<InsuranceSelectionPage> {
  String? selectedPlan;

  final List<Map<String, String>> insuranceOptions = [
    {'title': 'Basic', 'description': 'Covers damages up to \$5,000'},
    {
      'title': 'Standard',
      'description': 'Covers damages up to \$20,000 + Theft',
    },
    {'title': 'Premium', 'description': 'Full coverage + Roadside assistance'},
  ];

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Select Insurance")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                booking.imagePath ?? 'assets/placeholder.png',
                height: 150,
              ),
              const SizedBox(height: 16),
              Text(
                booking.carName ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${booking.carPrice?.toStringAsFixed(2) ?? '0'} / day',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              Column(
                children:
                    insuranceOptions.map((option) {
                      final isSelected = selectedPlan == option['title'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPlan = option['title'];
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white10 : Colors.black,
                            border: Border.all(
                              color: isSelected ? Colors.blue : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              option['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(option['description']!),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                    )
                                    : const Icon(
                                      Icons.circle_outlined,
                                      color: Colors.grey,
                                    ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      selectedPlan != null
                          ? () {
                            Provider.of<BookingProvider>(
                              context,
                              listen: false,
                            ).setInsurance(selectedPlan!);
                            Navigator.pushNamed(context, '/checkout');
                          }
                          : null,
                  child: const Text("Continue to Checkout"),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
