import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = "Student";
  String userEmail = "student@example.com";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load stored user data from Hive
  void _loadUserData() async {
    var box = await Hive.openBox('userBox');
    setState(() {
      userName = box.get('username', defaultValue: 'Student');
      userEmail = box.get('email', defaultValue: 'student@example.com');
    });
  }

  // ✅ Logout function
  Future<void> _logout(BuildContext context) async {
    var box = await Hive.openBox('userBox');
    await box.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF0D1B2A);
    const Color cardColor = Color(0xFF1B263B);
    const Color accentMint = Color(0xFF10B981);
    const Color blue = Color(0xFF2563EB);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [blue, accentMint],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      backgroundColor: darkBg,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Info
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: blue.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: accentMint,
                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // About App
            _buildTile(
              icon: Icons.info_outline,
              title: "About Mentora",
              subtitle: "Know more about this app",
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: cardColor,
                    title: const Text("About Mentora",
                        style: TextStyle(color: accentMint)),
                    content: const Text(
                      "Mentora: Your Personal Offline AI Mentor — helping students learn, revise, and practice through AI answers, personal notes, and quizzes, all in one place.",
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close",
                            style: TextStyle(color: accentMint)),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Privacy Policy
            _buildTile(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read our app privacy policy",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Privacy Policy coming soon...")),
                );
              },
            ),

            // Rate This App
            _buildTile(
              icon: Icons.star_rate_rounded,
              title: "Rate This App",
              subtitle: "Give feedback or rating",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Rating feature will be added soon!")),
                );
              },
            ),

            // Logout
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text(
                "Logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: accentMint,
                foregroundColor: Colors.black,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    const Color cardColor = Color(0xFF1B263B);
    const Color accentMint = Color(0xFF10B981);
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: accentMint, size: 28),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 13)),
        trailing:
        const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 18),
        onTap: onTap,
      ),
    );
  }
}
