import 'dart:convert';

class Usuario {
  int id;
  String username;
  String email;
  List<String> roles;
  String token;
  String type;

  Usuario({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.token,
    required this.type,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        token: json["token"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "token": token,
        "type": type,
      };

  Map<String, dynamic> loginRequest(String email, String password) => {
        "email": email,
        "password": password,
      };
}