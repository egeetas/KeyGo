import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RentalProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _rentals = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get rentals => _rentals;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRentals(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot =
          await _firestore
              .collection('rentals')
              .where('userId', isEqualTo: userId)
              .get();

      _rentals =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
    } catch (e) {
      _error = 'Failed to load rentals: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteRental(String docId) async {
    try {
      await _firestore.collection('rentals').doc(docId).delete();
      _rentals.removeWhere((r) => r['id'] == docId);
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete rental: $e';
      notifyListeners();
    }
  }

  Future<void> cancelRental(String docId) async {
    try {
      await _firestore.collection('rentals').doc(docId).update({
        'status': 'cancelled',
      });

      final index = _rentals.indexWhere((r) => r['id'] == docId);
      if (index != -1) {
        _rentals[index]['status'] = 'cancelled';
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to cancel rental: $e';
      notifyListeners();
    }
  }
}
