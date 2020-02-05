import 'package:flutter/cupertino.dart';
import 'package:vocab_app_fyp55/provider/databaseProvider.dart';

class DatabaseNotifier extends ChangeNotifier {
  final dbHelper = DatabaseProvider.instance;
}