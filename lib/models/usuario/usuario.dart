import 'dart:convert';

class Usuario {
  int? idUsuario;
  String? username;
  String? nombre;
  String? email;
  String? password;

  Usuario({
    this.idUsuario,
    this.nombre,
    this.username,
    this.email,
    this.password,
  });

  factory Usuario.fromJson(String str) => Usuario.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Usuario.fromMap(Map<String, dynamic> json) => Usuario(
        username: json["username"],
        nombre: json["nombre"],
        email: json["email"],
        password: json["password"],
      ); 

  Map<String, dynamic> toMap() => {
        if (idUsuario != null) "idUsuario": idUsuario,
        if (username != null) "username": username,
        if (nombre != null) "nombre": nombre,
        if (email != null) "email": email,
        if (password != null) "password": password,
      };
}
