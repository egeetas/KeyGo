import 'package:keygo_deneme/utils/user_models.dart';

class AuthUtils {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static bool get isLoggedIn => _currentUser != null;

  static void login({required String name, required String email}) {
    final nameParts = name.trim().split(' ');
    String firstName = nameParts.first;
    String lastName = nameParts.length > 1 ? nameParts.skip(1).join(' ') : '';

    _currentUser = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '+90 555 123 4567',
    );
  }

  static void logout() {
    _currentUser = null;
  }
}
