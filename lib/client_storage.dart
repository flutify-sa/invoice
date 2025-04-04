// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ClientStorage {
  static Future<String> get _baseDir async {
    final directory = await getApplicationDocumentsDirectory();
    final appDir = Directory('${directory.path}/InvoiceApp');
    if (!await appDir.exists()) {
      await appDir.create();
    }
    return appDir.path;
  }

  static Future<String> get _clientsDir async {
    final baseDir = await _baseDir;
    final clientsDir = Directory('$baseDir/clients');
    if (!await clientsDir.exists()) {
      await clientsDir.create();
    }
    return clientsDir.path;
  }

  static Future<List<String>> loadClients() async {
    final baseDir = await _baseDir;
    final file = File('$baseDir/clients.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      return List<String>.from(jsonDecode(contents));
    }
    return [];
  }

  static Future<void> saveClients(List<String> clients) async {
    final baseDir = await _baseDir;
    final file = File('$baseDir/clients.json');
    await file.writeAsString(jsonEncode(clients));
  }

  static Future<void> createClientFile(String clientName) async {
    final clientsDir = await _clientsDir;
    final file = File(
        '$clientsDir/${clientName.toLowerCase().replaceAll(' ', '_')}.json');
    if (!await file.exists()) {
      final initialData = {
        'name': clientName,
        'invoices': [],
        'last_updated': DateTime.now().toIso8601String(),
      };
      await file.writeAsString(jsonEncode(initialData));
    }
  }

  static Future<Map<String, dynamic>> loadClientData(String clientName) async {
    final clientsDir = await _clientsDir;
    final file = File(
        '$clientsDir/${clientName.toLowerCase().replaceAll(' ', '_')}.json');
    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents) as Map<String, dynamic>;
    }
    return {};
  }

  static Future<void> saveClientData(
      String clientName, Map<String, dynamic> data) async {
    final clientsDir = await _clientsDir;
    final file = File(
        '$clientsDir/${clientName.toLowerCase().replaceAll(' ', '_')}.json');
    await file.writeAsString(jsonEncode(data));
  }
}
