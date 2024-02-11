import 'dart:convert';
import 'dart:typed_data';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Map currentUser = {};

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
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      await _saveUserDataLocally(responseData);

      return true;
    } else {
      return false;
    }
  }

  Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', json.encode(userData));
  }

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    http.Response response =
        await http.get(Uri.parse("http://localhost:8080/api/v2/user/$userId"));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
  }

  Future<bool> isSignedIn() async {
    // TODO: Fetch currentUser and check if its != null. (as return)

    // For testing purposes
    return false;
  }

  Future<String> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final Map<String, dynamic> userData = json.decode(userDataString);
      final id = userData['id'];
      return id.toString();
    }
    return "";
  }

  // Profile Setup
  Future<void> profileSetup(
      Uint8List photo,
      String userId,
      String name,
      String gender,
      String interestedIn,
      DateTime age,
      Position position) async {
    print("ja");
    // TODO: Store in database
  }
}
