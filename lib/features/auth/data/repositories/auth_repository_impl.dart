import 'package:cloud_firestore/cloud_firestore.dart'; // Add this
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Firebase Authentication and Firestore
class AuthRepositoryImpl implements AuthRepository {
  /// Instance of Firebase Authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Instance of Firebase Firestore for user data management
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  /// Authenticates an admin with email and password
  Future<void> signInAdmin(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  /// Authenticates a client with email and password
  Future<void> signInClient(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  /// Registers a new client and creates their profile in Firestore
  Future<void> signUpClient(String email, String password) async {
    // 1. Create the user in Firebase Auth
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // 2. Create the user document in Firestore to store their role
    final uid = userCredential.user?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).set({
        'email': email.trim(),
        'role': 'client', // Default role for portal signups
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  /// Signs out the currently authenticated user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  /// Returns a stream of the current authentication state
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
