import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'typenotes.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'AskToAIPage.dart';
import 'PDFReaderScreen.dart';
import 'QuizPage.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String email;

  const HomeScreen({super.key, required this.userName, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> allGrades = {};
  List<dynamic> subjects = [];
  List<dynamic> chapters = [];
  List<dynamic> topics = [];

  String? selectedGrade = '11';
  String? selectedSubjectId;
  String? selectedChapterId;
  String? selectedTopicId;
  String topicContent = '';

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final String data = await rootBundle.loadString('assets/data/syllubas.json');
    final jsonResult = json.decode(data);
    setState(() {
      allGrades = jsonResult;
      subjects = allGrades[selectedGrade]?['subjects'] ?? [];
    });
  }

  void onGradeSelected(String? grade) {
    setState(() {
      selectedGrade = grade;
      selectedSubjectId = null;
      selectedChapterId = null;
      selectedTopicId = null;
      subjects = allGrades[grade]?['subjects'] ?? [];
      chapters = [];
      topics = [];
      topicContent = '';
    });
  }

  void onSubjectSelected(String? id) {
    setState(() {
      selectedSubjectId = id;
      selectedChapterId = null;
      selectedTopicId = null;
      chapters = subjects.firstWhere((s) => s['id'] == id)['chapters'];
      topics = [];
      topicContent = '';
    });
  }

  void onChapterSelected(String? id) {
    setState(() {
      selectedChapterId = id;
      selectedTopicId = null;
      topics = chapters.firstWhere((c) => c['id'] == id)['topics'];
      topicContent = '';
    });
  }

  void onTopicSelected(String? id) {
    setState(() {
      selectedTopicId = id;
      topicContent = topics.firstWhere((t) => t['id'] == id)['content'];
    });
  }

  // Drawer Builder
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF102A43),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.school, color: Colors.tealAccent, size: 45),
                const SizedBox(height: 10),
                Text(
                  'Hi, ${widget.userName}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  '“Study smart, not hard!”',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 13),
                ),
              ],
            ),
          ),

          _drawerTile(Icons.home, "Home", () => Navigator.pop(context)),
          _drawerTile(Icons.smart_toy_outlined, "Ask to AI", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AskToAIPage()));
          }),
          _drawerTile(Icons.quiz, "Quiz", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizPage()));
          }),
          _drawerTile(Icons.book, "Read PDF", () {
            Navigator.pop(context);
            String pdfPath = selectedGrade == '11'
                ? 'assets/data/PHY11.pdf'
                : 'assets/data/PHY12.pdf';
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PDFReaderScreen(pdfPath: pdfPath)),
            );
          }),
          _drawerTile(Icons.note_alt_outlined, "Type Notes", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TypeNotesPage()));
          }),
          _drawerTile(Icons.settings, "Settings", () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),

          const Divider(color: Colors.white54),

          _drawerTile(Icons.logout, "Logout", () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
            );
          }, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _drawerTile(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.tealAccent),
      title: Text(label, style: TextStyle(color: color ?? Colors.white)),
      onTap: onTap,
    );
  }

  // ---------------- UI BUILD ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Welcome, ${widget.userName}",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Keep Learning • Keep Growing ",
              style: TextStyle(color: Colors.tealAccent, fontSize: 13),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 90, 16, 16),
          child: Column(
            children: [
              // Animated Header
              AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.tealAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Text(
                  " Choose Grade, Subject, Chapter & Topic",
                  style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Dropdown Section
              _buildDropdownCard(
                value: selectedGrade,
                hint: 'Select Grade',
                items: allGrades.keys.map((grade) => DropdownMenuItem(
                  value: grade,
                  child: Text('Grade $grade', style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: onGradeSelected,
              ),
              _buildDropdownCard(
                value: selectedSubjectId,
                hint: 'Select Subject',
                items: subjects.map((s) => DropdownMenuItem(
                  value: s['id'].toString(),
                  child: Text(s['name'], style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: onSubjectSelected,
              ),
              _buildDropdownCard(
                value: selectedChapterId,
                hint: 'Select Chapter',
                items: chapters.map((c) => DropdownMenuItem(
                  value: c['id'].toString(),
                  child: Text(c['name'], style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: onChapterSelected,
              ),
              _buildDropdownCard(
                value: selectedTopicId,
                hint: 'Select Topic',
                items: topics.map((t) => DropdownMenuItem(
                  value: t['id'].toString(),
                  child: Text(t['title'], style: const TextStyle(color: Colors.white)),
                )).toList(),
                onChanged: onTopicSelected,
              ),

              const SizedBox(height: 20),

              // Content Display
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B263B).withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      topicContent.isEmpty
                          ? ' Select a topic to start learning...'
                          : topicContent,
                      style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Quick Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const TypeNotesPage())),
                    icon: const Icon(Icons.note_alt_outlined),
                    label: const Text("My Notes"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent.withOpacity(0.8),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const AskToAIPage())),
                    icon: const Icon(Icons.smart_toy_outlined),
                    label: const Text("Ask AI"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.withOpacity(0.8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              const Text(
                '"Small steps every day lead to big success."',
                style: TextStyle(color: Colors.tealAccent, fontSize: 13, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Dropdown UI
  Widget _buildDropdownCard({
    required String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return Card(
      color: const Color(0xFF1B263B).withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonFormField<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Color(0xFF9BA4B4))),
          items: items,
          onChanged: onChanged,
          dropdownColor: const Color(0xFF1B263B),
          decoration: const InputDecoration(border: InputBorder.none),
          iconEnabledColor: Colors.tealAccent,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
