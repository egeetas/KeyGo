import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/booking_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    final pricePerDay = booking.carPrice ?? 0;
    final dayCount = booking.dayCount;
    final subtotal = pricePerDay * dayCount;
    final tax = subtotal * 0.2;
    final total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body:
          booking.carName == null
              ? const Center(
                child: Text(
                  "No booking found.\nPlease go back and try again.",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
              : Column(
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Image.asset(
                            booking.imagePath ?? 'assets/placeholder.png',
                            height: 80,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Brand',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                booking.carName!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text('Duration: $dayCount days'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('\$${subtotal.toStringAsFixed(2)}'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text('\$${subtotal.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Taxes (20%)'),
                        Text('\$${tax.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        if (user == null) return;

                        await FirebaseFirestore.instance
                            .collection('rentals')
                            .add({
                              'userId': user.uid,
                              'carName': booking.carName,
                              'carPrice': subtotal,
                              'insurancePlan': booking.insurancePlan ?? 'None',
                              'pickupLocation':
                                  booking.pickupLocation ?? 'Unknown',
                              'pickupTime':
                                  booking.pickupDate?.toIso8601String(),
                              'returnTime':
                                  booking.returnDate?.toIso8601String(),
                              'status': 'confirmed',
                              'imagePath': booking.imagePath ?? '',
                              'createdAt': Timestamp.now(),
                              'totalPrice': total,
                            });

                        booking.reset();

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
