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
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> addTodo(String title, String isi) async {
    final http.Response response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'title': title, 'isi': isi}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> editTodo(
    String id,
    String title,
    String isi,
  ) async {
    final http.Response response = await http.put(
      Uri.parse(url + id),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'title': title, 'isi': isi}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deleteTodo(String id) async {
    final http.Response response = await http.delete(Uri.parse(url + id));
    return jsonDecode(response.body);
  }
}
