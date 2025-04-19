import 'package:flutter/material.dart';
import 'dart:math';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  final List<String> notificationMessages = const [
    "🚗 Your Fiat 500e rental starts in 30 minutes.",
    "🔋 BMW i3 battery is 80% charged and ready to go!",
    "🅿️ Your reserved parking spot is confirmed near your pickup location.",
    "💸 New promo: Rent an Audi for 20% off today only!",
    "📍 Your rental car is now available at Sabancı University.",
    "⏰ Reminder: Your rental ends in 1 hour. Need more time?",
    "✅ Car check-in completed. Hope you had a great ride!",
    "🔥 Popular: 5 users viewed this BMW in the last 10 mins!",
    "🛠️ Maintenance check complete. Car is ready for rental.",
    "🌦️ Rain is expected. Free umbrella in the glove box!",
  ];

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final displayedNotifications = List.generate(
      10,
      (_) => notificationMessages[random.nextInt(notificationMessages.length)],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: displayedNotifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications, color: Colors.cyan),
            title: Text(displayedNotifications[index]),
            tileColor: Colors.grey[900],
            textColor: Colors.white,
          );
        },
      ),
    );
  }
}
