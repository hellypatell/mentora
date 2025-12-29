import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // for rootBundle

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  Map<String, dynamic>? _quizData;
  String? _selectedStd;
  String? _selectedSubject;
  List<dynamic> _questions = [];
  int _currentQuestion = 0;
  String _selectedOption = '';
  int _score = 0;
  bool _quizCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    final String jsonString = await rootBundle.loadString('assets/data/quiz.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _quizData = jsonData;
    });
  }

  void _startQuiz() {
    if (_selectedStd != null && _selectedSubject != null && _quizData != null) {
      setState(() {
        _questions = _quizData![_selectedStd][_selectedSubject];
        _currentQuestion = 0;
        _score = 0;
        _quizCompleted = false;
        _selectedOption = '';
      });
    }
  }

  void _nextQuestion() {
    if (_selectedOption.isEmpty) return;

    if (_selectedOption == _questions[_currentQuestion]['answer'].toString()) {
      _score++;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = '';
      });
    } else {
      setState(() {
        _quizCompleted = true;
      });
    }
  }

  void _retakeQuiz() {
    setState(() {
      _questions = [];
      _currentQuestion = 0;
      _score = 0;
      _quizCompleted = false;
      _selectedOption = '';
      _selectedStd = null;
      _selectedSubject = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
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
            'Mentora Quiz',
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
              icon: const Icon(Icons.info_outline, color: Colors.white),
              tooltip: "Quiz Info",
              onPressed: () {
                // Optional: show quiz instructions
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              tooltip: "Reset Quiz",
              onPressed: _retakeQuiz,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Standard Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select Standard',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color(0xFF1B263B),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              dropdownColor: const Color(0xFF1B263B),
              value: _selectedStd,
              items: _quizData!.keys
                  .map((std) => DropdownMenuItem(
                value: std,
                child: Text(
                  std,
                  style: const TextStyle(color: Colors.white),
                ),
              ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _selectedStd = val;
                  _selectedSubject = null;
                  _questions = [];
                  _quizCompleted = false;
                });
              },
            ),
            const SizedBox(height: 16),

            // Subject Dropdown
            if (_selectedStd != null)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Subject',
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: const Color(0xFF1B263B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                dropdownColor: const Color(0xFF1B263B),
                value: _selectedSubject,
                items: (_quizData![_selectedStd] as Map<String, dynamic>)
                    .keys
                    .map((subject) => DropdownMenuItem(
                  value: subject,
                  child: Text(
                    subject,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedSubject = val;
                    _questions = [];
                    _quizCompleted = false;
                  });
                },
              ),
            const SizedBox(height: 16),

            // Start Quiz Button
            if (_selectedStd != null && _selectedSubject != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF10B981),
                ),
                onPressed: _startQuiz,
                child: const Text(
                  'Start Quiz',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            const SizedBox(height: 16),

            // Quiz Display
            if (_questions.isNotEmpty && !_quizCompleted)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress
                    LinearProgressIndicator(
                      value: (_currentQuestion + 1) / _questions.length,
                      color: const Color(0xFF10B981),
                      backgroundColor: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),

                    // Question Card
                    Card(
                      color: const Color(0xFF1B263B),
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Q${_currentQuestion + 1}: ${_questions[_currentQuestion]['question']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Options
                    ...(_questions[_currentQuestion]['options'] as List<dynamic>).map(
                          (option) => Card(
                        color: _selectedOption == option ? const Color(0xFF10B981) : const Color(0xFF1B263B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: RadioListTile<String>(
                          value: option.toString(),
                          groupValue: _selectedOption,
                          activeColor: Colors.white,
                          title: Text(
                            option.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _selectedOption = val!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Next Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: const Color(0xFF10B981),
                      ),
                      onPressed: _nextQuestion,
                      child: const Text(
                        'Next',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),

            // Quiz Completed
            if (_quizCompleted)
              Expanded(
                child: Center(
                  child: Card(
                    color: const Color(0xFF1B263B),
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        '🎉 Quiz Completed!\nYour Score: $_score / ${_questions.length}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
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
