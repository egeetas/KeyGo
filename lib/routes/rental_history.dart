import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/rental_provider.dart';
import 'package:keygo_deneme/providers/auth_provider.dart' as myauth;
import 'package:intl/intl.dart';

class RentalHistory extends StatefulWidget {
  const RentalHistory({super.key});

  @override
  State<RentalHistory> createState() => _RentalHistoryState();
}

class _RentalHistoryState extends State<RentalHistory> {
  final DateFormat _formatter = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId =
          Provider.of<myauth.AuthProvider>(context, listen: false).user?.uid;
      if (userId != null) {
        Provider.of<RentalProvider>(
          context,
          listen: false,
        ).fetchRentals(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rentalProvider = Provider.of<RentalProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rentals')),
      backgroundColor: Colors.black,

      body:
          rentalProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : rentalProvider.error != null
              ? Center(
                child: Text(
                  rentalProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : rentalProvider.rentals.isEmpty
              ? const Center(
                child: Text(
                  'No rentals yet.',
                  style: TextStyle(color: Colors.white70),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: rentalProvider.rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentalProvider.rentals[index];
                  final rentalId = rental['id'];

                  final pickupDate =
                      DateTime.tryParse(rental['pickupTime'] ?? '') ??
                      DateTime.now();
                  final returnDate =
                      DateTime.tryParse(rental['returnTime'] ?? '') ??
                      DateTime.now();
                  final totalPrice = rental['totalPrice'] ?? 0.0;

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          if (rental['imagePath'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                rental['imagePath'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            const Icon(
                              Icons.directions_car,
                              color: Colors.white,
                              size: 60,
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rental['carName'] ?? 'Unknown Car',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'Status: ${rental['status'] ?? 'unknown'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Pickup: ${rental['pickupLocation'] ?? 'N/A'}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'From: ${_formatter.format(pickupDate)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'To: ${_formatter.format(returnDate)}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Total: \$${totalPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onSelected: (value) async {
                              if (value == 'cancel') {
                                await Provider.of<RentalProvider>(
                                  context,
                                  listen: false,
                                ).cancelRental(rentalId);
                              } else if (value == 'delete') {
                                await Provider.of<RentalProvider>(
                                  context,
                                  listen: false,
                                ).deleteRental(rentalId);
                              }
                            },
                            itemBuilder:
                                (context) => const [
                                  PopupMenuItem(
                                    value: 'cancel',
                                    child: Text('Cancel Rental'),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete Rental'),
                                  ),
                                ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
