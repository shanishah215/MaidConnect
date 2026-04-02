import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../shared/domain/entities/user_role.dart';

class AuthState extends ChangeNotifier {
  AuthState._() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      _isInitialising = true; 
      notifyListeners();

      if (user == null) {
        _clientAuthenticated = false;
        _adminAuthenticated = false;
        _isInitialising = false; // Done loading
        notifyListeners();
        return;
      }

      // Fetch the role from Firestore
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(const GetOptions(source: Source.serverAndCache));
        
        final role = doc.data()?['role'] as String?;
        print('User Logged In: ${user.email}, Role: $role'); 

        if (role == 'admin') {
          _adminAuthenticated = true;
          _clientAuthenticated = false;
        } else {
          _clientAuthenticated = true;
          _adminAuthenticated = false;
        }
      } catch (e) {
        print('Error fetching role: $e'); 
        _clientAuthenticated = true; 
        _adminAuthenticated = false;
      }

      _isInitialising = false; // Done loading
      notifyListeners();
    });
  }

  static final AuthState instance = AuthState._();

  bool _clientAuthenticated = false;
  bool _adminAuthenticated = false;
  bool _isInitialising = true; // NEW: Starts in loading state

  bool get isClientAuthenticated => _clientAuthenticated;
  bool get isAdminAuthenticated => _adminAuthenticated;
  bool get isInitialising => _isInitialising; // NEW: Getter

  UserRole get currentRole {
    if (_adminAuthenticated) return UserRole.admin;
    if (_clientAuthenticated) return UserRole.client;
    return UserRole.guest;
  }

  // These manual methods are now mostly for debugging or forced login tests
  // since the listener above handles the heavy lifting.
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
    FirebaseAuth.instance.signOut();
  }
}
