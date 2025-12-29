import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TypeNotesPage extends StatefulWidget {
  const TypeNotesPage({super.key});

  @override
  State<TypeNotesPage> createState() => _TypeNotesPageState();
}

class _TypeNotesPageState extends State<TypeNotesPage> {
  final TextEditingController _controller = TextEditingController();
  Box<String>? notesBox;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    notesBox = Hive.box<String>('notesBox');
    setState(() {}); // refresh UI once box is ready
  }

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isEmpty || notesBox == null) return;

    notesBox!.add(text);
    _controller.clear();
    setState(() {});
  }

  void _deleteNote(int index) {
    if (notesBox == null) return;

    notesBox!.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (notesBox == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final notes = notesBox!.values.toList().reversed.toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Polished AppBar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Ripple effect on back button
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'My Notes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), // keeps title visually centered
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Type your note here...',
                    hintStyle: const TextStyle(color: Color(0xFF778DA9)),
                    filled: true,
                    fillColor: const Color(0xFF1B263B),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF00BFA6)),
                      onPressed: _addNote,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (_) => _addNote(),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: notes.isEmpty
                      ? const Center(
                    child: Text(
                      'No notes yet. Start typing!',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: const Color(0xFF1B263B),
                        elevation: 5,
                        shadowColor: Colors.black54,
                        child: ListTile(
                          title: Text(
                            notes[index],
                            style: const TextStyle(
                                color: Color(0xFFE0E1DD), fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () =>
                                _deleteNote(notesBox!.length - 1 - index),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF00BFA6),
      ),
    );
  }
}
