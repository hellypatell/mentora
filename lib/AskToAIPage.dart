import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AskToAIPage extends StatefulWidget {
  const AskToAIPage({super.key});

  @override
  State<AskToAIPage> createState() => _AskToAIPageState();
}

class _AskToAIPageState extends State<AskToAIPage> {
  final TextEditingController _controller = TextEditingController();
  String _answer = "";
  bool _loading = false;
  String _displayedAnswer = "";
  String _lastQuestion = "";

  late Box _aiBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  /// Initialize Hive and load last question
  Future<void> _initHive() async {
    await Hive.initFlutter();
    _aiBox = await Hive.openBox('askToAIBox');
    setState(() {
      _lastQuestion = _aiBox.get('last_question', defaultValue: '') ?? '';
    });
  }

  /// Save last question
  Future<void> _saveLastQuestion(String question) async {
    await _aiBox.put('last_question', question);
    setState(() {
      _lastQuestion = question;
    });
  }

  /// Standard Ask
  Future<void> _askAI() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    await _saveLastQuestion(question);
    _askAIWithPrompt(question);
  }

  /// Simplify Answer
  void _simplifyAnswer() {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    final simplifiedPrompt = "Simplify this answer for a student: $question";
    _askAIWithPrompt(simplifiedPrompt);
  }

  /// Core: call Flask backend
  Future<void> _askAIWithPrompt(String prompt) async {
    setState(() {
      _answer = "";
      _displayedAnswer = "";
      _loading = true;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/ask"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"prompt": prompt}),
      );

      if (response.statusCode == 200) {
        _answer = response.body;
        _typeAnswer(_answer);
      } else {
        setState(() {
          _displayedAnswer = "❌ Server error: ${response.statusCode}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _displayedAnswer = "❌ Error: $e";
        _loading = false;
      });
    }
  }

  /// Typing animation
  void _typeAnswer(String fullText) async {
    _displayedAnswer = "";
    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      setState(() {
        _displayedAnswer += fullText[i];
      });
    }
    setState(() {
      _loading = false;
    });
  }

  /// Copy answer
  void _copyAnswer() {
    if (_displayedAnswer.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _displayedAnswer));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Answer copied!")),
      );
    }
  }

  /// Clear
  void _clearAll() {
    _controller.clear();
    setState(() {
      _answer = "";
      _displayedAnswer = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF2563EB);
    const Color accentMint = Color(0xFF10B981);
    const Color darkBg = Color(0xFF0D1B2A);
    const Color cardBg = Color(0xFF1B263B);

    return Scaffold(
      backgroundColor: darkBg,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'Ask to AI',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.copy, color: Colors.white),
              tooltip: "Copy Answer",
              onPressed: _displayedAnswer.isEmpty ? null : _copyAnswer,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              tooltip: "Clear Question",
              onPressed: _clearAll,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_lastQuestion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "🕓 Last question: $_lastQuestion",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),

            // Input
            TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Ask a question",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (_) => _askAI(),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _askAI,
                    icon: const Icon(Icons.send),
                    label: const Text("Ask"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentMint,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _simplifyAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  child: const Text("Simplify"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _loading
                        ? "⏳ Thinking...\n\n$_displayedAnswer"
                        : _displayedAnswer.isEmpty
                        ? "💬 Type a question to get help from Mentora!"
                        : _displayedAnswer,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
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
