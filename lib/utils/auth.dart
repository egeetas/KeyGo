import 'package:firebase_auth/firebase_auth.dart';

class AuthUtils {
  /// Kullanıcıyı email & şifre ile giriş yaptırır
  static Future<void> login({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Kullanıcıyı email & şifre ile kaydeder
  static Future<void> register({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Firebase oturumunu sonlandırır
  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Mevcut kullanıcıyı döndürür
  static User? get currentUser => FirebaseAuth.instance.currentUser;
}
