import 'dart:io';

import 'package:geolocator/geolocator.dart';
class UserRepository {

  Future<void> signInWithEmail(String email, String password) async {
    http.Response response =
    await http.post(Uri.parse('http://localhost:8080/api/v1/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': email,
          'password': password,
        }));

    print(response.body);
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
  Future<void> profileSetup(
      File photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      Geolocator location) async {
    // TODO: Store in database
  }
}