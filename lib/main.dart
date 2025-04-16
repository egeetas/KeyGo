import 'package:flutter/material.dart';
import 'package:keygo_deneme/routes/login_screen.dart';
import 'package:keygo_deneme/routes/home_screen.dart';
import 'package:keygo_deneme/routes/profile_screen.dart';
import 'package:keygo_deneme/routes/cars_screen.dart';
import 'package:keygo_deneme/routes/vehicle_details.dart';
import 'package:keygo_deneme/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KeyGo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          brightness: Brightness.dark,
          primary: Colors.black,
          secondary: Colors.white,
          surface: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white.withAlpha(26),
          hintStyle: TextStyle(color: Colors.white.withAlpha(128)),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      // Named routes tanımları
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.profile: (context) => const ProfileScreen(),
        Routes.cars: (context) => const CarsScreen(),
      },
      // Parametreli rotaları onGenerateRoute ile yönetiyoruz
      onGenerateRoute: (settings) {
        if (settings.name == Routes.vehicleDetails) {
          // Araç ID'sini parametre olarak al
          final carId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(carId: carId),
          );
        }
        return null;
      },
    );
  }
}
