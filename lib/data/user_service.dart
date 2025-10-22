import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  Future<void> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Hier echte Login-Logik mit Firebase/Auth-Service
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', email);
  }

  Future<void> register(String firstName, String lastName, String email, 
                       String phone, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // Hier echte Registrierungs-Logik
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', '$firstName $lastName');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('user_email');
    await prefs.remove('user_name');
  }

  //User Daten:
  Map<String, String> getCurrentUser()  {
    return  {
      'id':'temp_user_123',
      'name': 'Aktueller Benutzer',
    };
  }

  // 🔥 OPTIONAL: Async-Version die aus SharedPreferences liest
  Future<Map<String, String>> getCurrentUserAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name') ?? 'Unbekannter Benutzer';
    final userEmail = prefs.getString('user_email') ?? 'unbekannt@email.com';
    
    return {
      'id': userEmail, // Verwende E-Mail als ID bis wir echte User-IDs haben
      'name': userName,
    };
  }
}