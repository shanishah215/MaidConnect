import 'package:cloud_firestore/cloud_firestore.dart'; // Add this
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Add this

  @override
  Future<void> signInAdmin(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signInClient(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
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
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
