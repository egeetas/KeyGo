import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  double _parsePrice(String priceString) {
    if (priceString.toLowerCase() == 'free') return 0.0;
    final cleaned = priceString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == null || args is! Map<String, String>) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No car selected.\nPlease go back and try again.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final carName = args['carName'] ?? 'Unknown';
    final carPrice = args['carPrice'] ?? '\$0';
    final imagePath = args['imagePath'] ?? 'assets/placeholder.png';

    final price = _parsePrice(carPrice);
    final tax = price * 0.2;
    final total = price + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: Image.asset(imagePath, height: 80)),
                const SizedBox(width: 8),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Brand', style: TextStyle(color: Colors.grey)),
                      Text(carName, style: const TextStyle(fontSize: 16)),
                      const Text('Quantity: 01'),
                    ],
                  ),
                ),
                Expanded(flex: 2, child: Text('\$${price.toStringAsFixed(2)}')),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal (1)'),
                Text('\$${price.toStringAsFixed(2)}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Taxes (20%)'),
                Text('\$${tax.toStringAsFixed(2)}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${total.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) return;

                await FirebaseFirestore.instance.collection('rentals').add({
                  'userId': user.uid,
                  'carName': carName,
                  'carPrice': price,
                  'insurancePlan': args['insurancePlan'] ?? 'None',
                  'createdAt': Timestamp.now(),
                  'status': 'confirmed',
                  'imagePath': imagePath,
                });

                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          backgroundColor: Colors.black,
                          title: const Text(
                            'Reservation Completed',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'Your car has been reserved successfully!',
                            style: TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/home',
                                  (route) => false,
                                );
                              },
                              child: const Text(
                                'OK',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }
}
