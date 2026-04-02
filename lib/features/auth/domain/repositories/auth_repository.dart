abstract class AuthRepository {
  Future<void> signInClient(String email, String password);
  Future<void> signInAdmin(String email, String password);
  Future<void> signUpClient(String email, String password);
  Future<void> signOut();
  Stream<dynamic> get authStateChanges;
}
