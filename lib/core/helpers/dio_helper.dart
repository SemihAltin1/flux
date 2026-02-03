import 'package:shared_preferences/shared_preferences.dart';

final class DioHelper {

  static Future<void> saveToken(String token) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token);
  }

  static Future<String?> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString("token");
    return token;
  }

  static Future<Map<String,String>> getHeader() async {
    final token = await getToken();
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
    return header;
  }

  static Map<String,String> defaultHeader() {
    final header = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    return header;
  }

}