import 'package:flutter/material.dart';

class EditProfileFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEditingName = false;
  String _username = '';
  String _newPassword = '';
  bool _didUpdate = false;

  String _currentPassword = '';

  String get  currentPassword => _currentPassword;

  set currentPassword(String currentPassword){
    _currentPassword = currentPassword;
    notifyListeners();
  }

  bool get didUpdate => _didUpdate;

  set didUpdate(bool didUpdate) {
    _didUpdate = didUpdate;
    notifyListeners();
  }

  String get newPassword =>  _newPassword;

  set newPassword(String newPassword) {
    _newPassword = newPassword;
    notifyListeners();
  }
  
  String get username =>  _username;

  set username(String nombre){
    _username = nombre;
    notifyListeners();
  }

  bool get isEditingName => _isEditingName;
  
  set isEditingName(bool value) {
    _isEditingName = value;
    notifyListeners();
  }
  
  bool get isLoading => _isLoading;

  
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());
    return formKey.currentState?.validate() ?? false;
  }
}