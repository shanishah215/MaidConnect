abstract class AuthRepository {
  Future<void> signInClient();
  Future<void> signInAdmin();
  Future<void> signOut();
}
