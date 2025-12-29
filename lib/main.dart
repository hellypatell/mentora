import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'Typenotes.dart';
import 'splash_screen.dart';
import 'user_model.dart';
import 'theme/theme_notifier.dart';
import 'settings_screen.dart';
import 'ollama_service.dart';
import 'package:syncfusion_flutter_core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Syncfusion license
  SyncfusionLicense.registerLicense('YOUR_LICENSE_KEY');

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(UserModelAdapter());

  // Open Hive boxes
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settingsBox');
  await Hive.openBox<String>('notesBox'); // <--- For TypeNotesPage

  // Add default admin if not present
  final userBox = Hive.box<UserModel>('users');
  if (!userBox.containsKey('admin@fixora.com')) {
    userBox.put(
      'admin@fixora.com',
      UserModel(
        name: 'Admin',
        email: 'admin@fixora.com',
        password: 'admin123',
        role: 'admin',
      ),
    );
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const FixoraApp(),
    ),
  );
}

class FixoraApp extends StatelessWidget {
  const FixoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Mentora',
      debugShowCheckedModeBanner: false,
      themeMode: themeNotifier.value,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D1B2A),
        primaryColor: const Color(0xFF00BFA6),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE0E1DD)),
          bodyMedium: TextStyle(color: Color(0xFF778DA9)),
        ),
      ),
      darkTheme: ThemeData.dark(),
      home: SplashScreen(),
      routes: {
        '/settings': (_) => const SettingsScreen(),
        '/type-notes': (_) => const TypeNotesPage(),
      },
    );
  }
}
