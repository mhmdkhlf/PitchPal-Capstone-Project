class Auth {
  const Auth({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

enum Role {
  player('player'),
  fieldManager('field manager');

  final String value;
  const Role(this.value);
}
