import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../routes/app_routes.dart';
import '../widgets/app_bottom_nav.dart';

class SampleItem {
  SampleItem({this.id, this.title, this.completed});
  int? id;
  String? title;
  bool? completed;

  factory SampleItem.fromJson(Map<String, dynamic> json) {
    return SampleItem(
      id: json['id'] == null ? 0 : json['id'] as int,
      title: json['title'] == null ? 'none' : json['title'] as String,
      completed: json['completed'] == null ? false : json['completed'] as bool,
    );
  }
}

Future<List<SampleItem>> fecthData() async {
  var res = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
  if (res.statusCode != 200) {
    throw Exception('bad internet');
  }
  var d = jsonDecode(res.body);
  List<SampleItem> xx = [];
  for (var i in d) {
    xx.add(SampleItem.fromJson(i));
  }
  return xx;
}

class SamplePage extends StatefulWidget {
  const SamplePage({super.key, this.fetchItems, this.deleteItem});
  final Future<List<SampleItem>> Function()? fetchItems;
  final Future<void> Function(int itemId)? deleteItem;

  @override
  _SamplePageState createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  late Future<List<SampleItem>> dataF;
  List<SampleItem> items = [];

  void setup() {
    dataF = (widget.fetchItems ?? fecthData)();
    dataF.then((value) {
      setState(() {
        items = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  deleteThis(int id) async {
    if (widget.deleteItem != null) {
      await widget.deleteItem!(id);
      setState(() {
        items.removeWhere((e) => e.id == id);
      });
      return;
    }

    var r = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/todos/$id'));
    if (r.statusCode == 200 || r.statusCode == 204) {
      setState(() {
        items.removeWhere((e) => e.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: dataF,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('error: ' + snap.error.toString()));
          }

          if (items.isEmpty) {
            return Center(child: Text('No items'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var x = items[index];
              return Card(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(x.title ?? ''),
                            Text((x.completed ?? false) ? 'Completed' : 'Pending'),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        deleteThis(x.id ?? 0);
                      },
                      child: Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.details);
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
