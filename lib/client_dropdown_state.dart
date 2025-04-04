// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:invoice/client_dropdown.dart';
import 'client_storage.dart';
import 'add_client_dialog.dart';

class ClientDropdownState extends State<ClientDropdown> {
  List<String> clients = [];
  String? selectedClient;
  final TextEditingController _clientController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final loadedClients = await ClientStorage.loadClients();
      setState(() {
        clients = loadedClients;
        if (clients.isNotEmpty) {
          selectedClient = clients[0];
        }
      });
    } catch (e) {
      print('Error loading clients: $e');
    }
  }

  Future<void> _saveClients() async {
    try {
      await ClientStorage.saveClients(clients);
    } catch (e) {
      print('Error saving clients: $e');
    }
  }

  Future<void> _addClient(String newClient) async {
    if (newClient.isNotEmpty) {
      setState(() {
        clients.add(newClient);
        selectedClient = newClient;
      });
      await _saveClients();
      await ClientStorage.createClientFile(
          newClient); // Auto-create client file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DropdownButtonFormField<String>(
            value: selectedClient,
            hint: const Text('Select a client'),
            items: clients.map((client) {
              return DropdownMenuItem<String>(
                value: client,
                child: Text(client),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedClient = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Client',
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddClientDialog(
                controller: _clientController,
                onAdd: _addClient,
              ),
            );
          },
          child: const Text('Add Client'),
        ),
      ],
    );
  }
}
