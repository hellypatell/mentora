
import 'package:flutter/material.dart';
import 'hive_db.dart';
import 'user_model.dart';
import 'login_screen.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  void loadUsers() {
    users = HiveDB.getUserBox().values.toList();
  }

  void deleteUser(int index) {
    final box = HiveDB.getUserBox();
    final key = box.keyAt(index);
    box.delete(key);
    setState(() {
      loadUsers();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User deleted")),
    );
  }

  void confirmDelete(int index, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B263B),
        title: const Text("Confirm Deletion", style: TextStyle(color: Color(0xFFE0E1DD))),
        content: Text(
          "Are you sure you want to delete user '$name'?",
          style: const TextStyle(color: Color(0xFF778DA9)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Color(0xFF00BFA6))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteUser(index);
            },
            child: const Text("Delete", style: TextStyle(color: Color(0xFFFF6B6B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFFE0E1DD),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: users.isEmpty
            ? const Center(
          child: Text(
            'No users registered yet.',
            style: TextStyle(color: Color(0xFF778DA9), fontSize: 18),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Users: ${users.length}',
              style: const TextStyle(
                color: Color(0xFF00BFA6),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserModel user = users[index];
                  return Card(
                    color: const Color(0xFF1B263B),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.person, color: Color(0xFF00BFA6)),
                      title: Text(
                        user.name,
                        style: const TextStyle(color: Color(0xFFE0E1DD), fontSize: 16),
                      ),
                      subtitle: Text(
                        user.email,
                        style: const TextStyle(color: Color(0xFF778DA9)),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: user.role == 'admin'
                                  ? Colors.redAccent
                                  : const Color(0xFF00BFA6),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.role.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (user.role != 'admin')
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => confirmDelete(index, user.name),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
