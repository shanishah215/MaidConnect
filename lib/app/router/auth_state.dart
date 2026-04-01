import 'package:flutter/foundation.dart';

import '../../shared/domain/entities/user_role.dart';

class AuthState extends ChangeNotifier {
  AuthState._();

  static final AuthState instance = AuthState._();

  bool _clientAuthenticated = false;
  bool _adminAuthenticated = false;

  bool get isClientAuthenticated => _clientAuthenticated;
  bool get isAdminAuthenticated => _adminAuthenticated;

  UserRole get currentRole {
    if (_adminAuthenticated) return UserRole.admin;
    if (_clientAuthenticated) return UserRole.client;
    return UserRole.guest;
  }

  void signInClient() {
    _clientAuthenticated = true;
    _adminAuthenticated = false;
    notifyListeners();
  }

  void signInAdmin() {
    _adminAuthenticated = true;
    _clientAuthenticated = false;
    notifyListeners();
  }

  void signOut() {
    _clientAuthenticated = false;
    _adminAuthenticated = false;
    notifyListeners();
  }
}
