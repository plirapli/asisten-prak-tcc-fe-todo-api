import 'dart:convert';
import 'package:http/http.dart' as http;

class TodoApi {
  static const url = "http://localhost:3001/todos/";

  static Future<Map<String, dynamic>> getTodo() async {
    final http.Response response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getTodoById(String id) async {
    final http.Response response = await http.get(Uri.parse(url + id));
    return jsonDecode(response.body)["data"];
  }

  static Future<Map<String, dynamic>> deleteTodo(String id) async {
    final http.Response response = await http.delete(Uri.parse(url + id));
    return jsonDecode(response.body);
  }
}
