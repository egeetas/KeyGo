import 'package:keygo_deneme/utils/user_models.dart';

/// Kullanıcı kimlik doğrulama işlemleri için basitleştirilmiş yardımcı sınıf
class AuthUtils {
  // Mevcut oturum açmış kullanıcı
  static User? _currentUser;

  /// Mevcut kullanıcıyı döndürür
  static User? get currentUser => _currentUser;

  /// Kullanıcının giriş yapmış olup olmadığını kontrol eder
  static bool get isLoggedIn => _currentUser != null;

  /// Basit giriş işlemi - giriş bilgileriyle yeni kullanıcı oluşturur
  static void login({required String name, required String email}) {
    // Adı parçalara ayır (boşluğa göre)
    final nameParts = name.trim().split(' ');
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    // Yeni kullanıcı oluştur
    _currentUser = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '+90 555 123 4567', // Varsayılan telefon
    );
  }

  /// Oturumu kapatır
  static void logout() {
    _currentUser = null;
  }
}
