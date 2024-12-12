import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  // Clave global para manejar el estado del formulario
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Campos del formulario
  String _email = '';
  String _password = '';

  // Getters y setters para email y password
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners(); // Notifica a los listeners para actualizar la UI si es necesario
  }

  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  // Método para validar el formulario
  bool validateForm() {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      return true;
    }
    return false;
  }
}
