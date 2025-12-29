import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart'; // ✅ For Clipboard

class AskToAIPage extends StatefulWidget {
  const AskToAIPage({super.key});

  @override
  State<AskToAIPage> createState() => _AskToAIPageState();
}

class _AskToAIPageState extends State<AskToAIPage> {
  final TextEditingController _controller = TextEditingController();
  String _answer = "";
  bool _loading = false;

  Future<void> _askAI() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      _answer = "";
      _loading = true;
    });

    final request = http.Request(
      "POST",
      Uri.parse("http://127.0.0.1:8000/ask"),
    );
    request.headers["Content-Type"] = "application/json";
    request.body = jsonEncode({"prompt": question});

    try {
      final response = await request.send();

      response.stream.transform(utf8.decoder).listen((chunk) {
        setState(() {
          _answer += chunk;
        });
      }, onDone: () {
        setState(() {
          _loading = false;
        });
      });
    } catch (e) {
      setState(() {
        _answer = "❌ Error: $e";
        _loading = false;
      });
    }
  }

  void _copyAnswer() {
    if (_answer.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _answer));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Answer copied!")),
      );
    }
  }

  void _clearAll() {
    _controller.clear();
    setState(() {
      _answer = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask to AI"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white), // ✅ White Copy
            tooltip: "Copy Answer",
            onPressed: _answer.isEmpty ? null : _copyAnswer,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white), // ✅ White Delete
            tooltip: "Clear Question",
            onPressed: _clearAll,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Ask a question",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _askAI(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _askAI,
              icon: const Icon(Icons.send),
              label: const Text("Ask"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _loading ? "⏳ Thinking...\n\n$_answer" : _answer,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
