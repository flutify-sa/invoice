// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ClientStorage {
  static Future<List<String>> loadClients() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/clients.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      return List<String>.from(jsonDecode(contents));
    }
    return [];
  }

  static Future<void> saveClients(List<String> clients) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/clients.json');
    await file.writeAsString(jsonEncode(clients));
  }
}
