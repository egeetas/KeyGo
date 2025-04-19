class User {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
