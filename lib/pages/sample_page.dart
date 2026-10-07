import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SampleItem {
  const SampleItem({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }
}

class SamplePage extends StatefulWidget {
  const SamplePage({super.key, this.fetchItems, this.deleteItem});

  final Future<List<SampleItem>> Function()? fetchItems;
  final Future<void> Function(int itemId)? deleteItem;

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  List<SampleItem> items = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<SampleItem>> _defaultFetch() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load data: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((item) => SampleItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> fetchData() async {
    try {
      final loadedItems = await (widget.fetchItems ?? _defaultFetch)();
      setState(() {
        items = loadedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> deleteItem(int itemId) async {
    if (widget.deleteItem != null) {
      await widget.deleteItem!(itemId);
      setState(() {
        items.removeWhere((item) => item.id == itemId);
      });
      return;
    }

    setState(() {
      items.removeWhere((item) => item.id == itemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(child: Text('${item.id}')),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item.completed ? 'Completed' : 'Pending'),
            trailing: ElevatedButton(
              onPressed: () => deleteItem(item.id),
              child: const Icon(Icons.delete),
            ),
          ),
        );
      },
    );
  }
}
