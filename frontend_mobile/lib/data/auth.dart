class LogInRequest {
  const LogInRequest({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  Map<String, dynamic> toJsonMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class SignUpRequest {
  const SignUpRequest({
    required this.email,
    required this.password,
    required this.role,
  });

  final String email;
  final String password;
  final Role role;

  Map<String, dynamic> toJsonMap() {
    return {
      'email': email,
      'password': password,
      'role': role.value,
    };
  }
}

enum Role {
  player('player'),
  fieldManager('field manager');

  final String value;
  const Role(this.value);
}
