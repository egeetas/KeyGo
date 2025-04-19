import 'package:flutter/material.dart';

class InsuranceSelectionPage extends StatefulWidget {
  final String carImagePath;
  final String carName;
  final String carPrice;

  const InsuranceSelectionPage({
    super.key,
    required this.carImagePath,
    required this.carName,
    required this.carPrice,
  });

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
    return Scaffold(
      appBar: AppBar(title: const Text("Select Insurance")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(widget.carImagePath, height: 150),
          const SizedBox(height: 16),
          Text(
            widget.carName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            '\$${widget.carPrice} / day',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed:
                  selectedPlan != null
                      ? () {
                        Navigator.pushNamed(
                          context,
                          '/checkout',
                          arguments: {
                            'carName': widget.carName,
                            'carPrice': '\$${widget.carPrice}',
                            'imagePath': widget.carImagePath,
                            'insurancePlan': selectedPlan!,
                          },
                        );
                      }
                      : null,
              child: const Text("Continue to Checkout"),
            ),
          ),
        ],
      ),
    );
  }
}
