class UserRepository {

  Future<void> signInWithEmail(String email, String password) async {
    print(email);
    print(password);
    // TODO: Login via the database and return
  }

  Future<bool> isFirstTime(String userId) async {
    bool? exists;
    // TODO: Check if user already exists in the database.
    exists = false;

    return exists;
  }

  Future<void> signUpWithEmail(String email, String password) async {
    print(email);
    print(password);
    // TODO: Register the user in the database and return
  }

  Future<void> signOut() async {
    // TODO: Return signOut
  }

  Future<bool> isSignedIn() async {
    // TODO: Fetch currentUser and check if its != null. (as return)

    // For testing purposes
    return false;
  }

  Future<String> getUser() async {
    // TODO: Get through the currentUser the UID
    // For testing purposes
    return "";
  }

  // Profile Setup
  Future<void> profileSetup() async {
    // TODO: Create user
  }
}