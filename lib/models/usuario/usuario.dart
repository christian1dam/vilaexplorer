import 'dart:convert';

class Usuario {
  int? id;
  String? username;
  String? email;
  String? password;
  List<String>? roles;
  String? token;
  String? type;

  Usuario({
    this.id,
    this.username,
    this.email,
    this.password,
    this.roles,
    this.token,
    this.type,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        roles: json["roles"] == null
            ? []
            : List<String>.from(json["roles"]!.map((x) => x)),
        token: json["token"],
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "roles": roles == null ? [] : List<dynamic>.from(roles!.map((x) => x)),
        "token": token,
        "type": type,
      };

  Map<String, dynamic> loginRequest() => {
        "email": email,
        "password": password,
      };

  Map<String, dynamic> registerRequest() =>
      {
        "nombre": username,
        "email": email,
        "password": password,
      };
}
