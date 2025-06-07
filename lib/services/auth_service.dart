import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> registerUser(Map<String, dynamic> userData) async {
  final response = await http.post(
    Uri.parse('http://localhost/capstonenew/my_flutter_api/register.php'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(userData),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success']) {
      // Registration successful
    } else {
      // Handle failure from PHP (e.g., email exists)
    }
  } else {
    // Handle server error (e.g., 500 or no response)
  }
}

Future<Map<String, dynamic>> loginUser(String username, String password) async {
  final response = await http.post(
    Uri.parse('http://localhost/capstonenew/my_flutter_api/login.php'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({'username': username, 'password': password}),
  );
  return jsonDecode(response.body);
}