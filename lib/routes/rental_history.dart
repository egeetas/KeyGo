import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/rental_provider.dart';
import 'package:keygo_deneme/providers/auth_provider.dart' as myauth;

class RentalHistory extends StatefulWidget {
  const RentalHistory({super.key});

  @override
  State<RentalHistory> createState() => _RentalHistoryState();
}

class _RentalHistoryState extends State<RentalHistory> {
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
      appBar: AppBar(title: const Text('Rental History')),
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

                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading:
                          rental['imagePath'] != null
                              ? Image.asset(
                                rental['imagePath'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              )
                              : const Icon(
                                Icons.directions_car,
                                color: Colors.white,
                              ),
                      title: Text(
                        rental['carName'] ?? 'Unknown Car',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Status: ${rental['status'] ?? 'unknown'}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
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
                    ),
                  );
                },
              ),
    );
  }
}
