import 'dart:convert';
import 'package:http/http.dart' as http;

class OllamaService {
  static const _baseUrl = 'http://127.0.0.1:8000';

  static Future<String> sendToPhi(String prompt) async {
    final url = Uri.parse('$_baseUrl/fix');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? '⚠️ No response content';
      } else {
        return '❌ HTTP ${response.statusCode}';
      }
    } catch (e) {
      return '❌ Exception: $e';
    }
  }
}
