import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'user_model.dart';

class HiveDB {
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>('users');
  }

  static Box<UserModel> getUserBox() => Hive.box<UserModel>('users');
}
