import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('RentalCarList sayfası açılıyor mu?', (WidgetTester tester) async {
    await tester.pumpWidget(CarRentalApp());

    // Uygulama ilk açıldığında 'Rental Car List' başlığını bekliyoruz
    expect(find.text('Rental Car List'), findsOneWidget);

    // Bir adet ElevatedButton (Choose) var mı kontrol edelim
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
