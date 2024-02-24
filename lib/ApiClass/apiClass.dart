import 'package:aph/baseurlp/baseurl.dart';
import 'package:http/http.dart' as http;

class ApiService {

  static Future<bool> registerUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(register),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      // Registration successful
      return true;
    } else {
      // Registration failed
      return false;
    }
  }


}
