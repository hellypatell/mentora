import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 1)
class NoteModel extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  String date;

  NoteModel({required this.text, required this.date});
}
