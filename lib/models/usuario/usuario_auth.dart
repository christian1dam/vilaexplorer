import 'dart:convert';

class UsuarioAuth {
  String? username;
  String? email;
  String? password;

  UsuarioAuth({
    this.username,
    this.email,
    this.password,
  });

  factory UsuarioAuth.fromJson(String str) => UsuarioAuth.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UsuarioAuth.fromMap(Map<String, dynamic> json) => UsuarioAuth(
        username: json["username"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toMap() => {
        "username": username,
        "email": email,
        "password": password,
      };

  Map<String, dynamic> loginRequest() => {
        "email": email,
        "password": password,
      };
}
