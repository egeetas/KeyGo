import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:keygo_deneme/providers/rental_provider.dart';
import 'package:keygo_deneme/providers/auth_provider.dart' as myauth;

import 'package:keygo_deneme/routes/login_screen.dart';
import 'package:keygo_deneme/routes/signup_screen.dart';
import 'package:keygo_deneme/routes/home_screen.dart';
import 'package:keygo_deneme/routes/cars_screen.dart';
import 'package:keygo_deneme/routes/vehicle_details.dart';
import 'package:keygo_deneme/routes/profile_screen.dart' as profile;
import 'package:keygo_deneme/routes/map_screen.dart' as mapScreen;
import 'package:keygo_deneme/routes/notifications_screen.dart';
import 'package:keygo_deneme/routes/checkout.dart';
import 'package:keygo_deneme/routes/insurance.dart';

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String cars = '/cars';
  static const String vehicleDetails = '/vehicleDetails';
  static const String insurance = '/insurance';
  static const String map = '/map';
  static const String checkout = '/checkout';
  static const String notifications = '/notifications';
  static const String sign = '/sign';
  static const String rentalhistory = '/rentalhistory';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => myauth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => RentalProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const AuthWrapper(),
      routes: {
        Routes.login: (context) => const LoginScreen(),
        Routes.sign: (context) => const SignUpScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.profile: (context) => const profile.ProfileScreen(),
        Routes.cars: (context) => const CarsScreen(),
        Routes.map: (context) => const mapScreen.MapScreen(),
        Routes.notifications: (context) => const NotificationsScreen(),
        Routes.checkout: (context) => const CheckoutPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == Routes.vehicleDetails) {
          final carId = settings.arguments as int?;
          if (carId == null) {
            return MaterialPageRoute(
              builder:
                  (context) => const ErrorScreen(message: 'Invalid car ID'),
            );
          }
          return MaterialPageRoute(
            builder: (context) => VehicleDetailsScreen(carId: carId),
          );
        }

        if (settings.name == Routes.insurance) {
          final args = settings.arguments as Map<String, dynamic>?;
          if (args == null) {
            return MaterialPageRoute(
              builder:
                  (context) => const ErrorScreen(
                    message: 'Invalid insurance parameters',
                  ),
            );
          }
          return MaterialPageRoute(
            builder:
                (context) => InsuranceSelectionPage(
                  carName: args['carName'] ?? 'Unknown Car',
                  carPrice: args['carPrice']?.toString() ?? '0',
                  carImagePath: args['carImagePath'] ?? 'assets/keygo_logo.png',
                ),
          );
        }

        return MaterialPageRoute(
          builder: (context) => const ErrorScreen(message: 'Route not found'),
        );
      },
      builder: (context, child) {
        return child ?? const CircularProgressIndicator();
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myauth.AuthProvider>(context).user;

    if (user == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
