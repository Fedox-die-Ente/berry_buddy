import 'dart:convert';

import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:geopoint/geopoint.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  Future<bool> signInWithEmail(String email, String password) async {
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
    return response.statusCode == 200;
  }

  Future<bool> isFirstTime(String userId) async {
    bool? exists;

    http.Response response =
      await http.get(Uri.parse("http://localhost:8080/api/v2/user/$userId"));

    exists = response.statusCode == 200;

    return exists;
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    http.Response response =
        await http.post(Uri.parse('http://localhost:8080/api/v1/register'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }));

    return response.statusCode == 200;
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
    return "1";
  }

  // Profile Setup
  Future<void> profileSetup(
      Uint8List photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      GeoPoint location) async {
    print("ja");
    // TODO: Store in database
  }
}
