/// Abstract repository handling authentication logic
abstract class AuthRepository {
  /// Sign in a client with email and password
  Future<void> signInClient(String email, String password);

  /// Sign in an admin with email and password
  Future<void> signInAdmin(String email, String password);

  /// Sign up a new client
  Future<void> signUpClient(String email, String password);

  /// Sign out the current user
  Future<void> signOut();

  /// Stream providing real-time authentication state updates
  Stream<dynamic> get authStateChanges;
}
