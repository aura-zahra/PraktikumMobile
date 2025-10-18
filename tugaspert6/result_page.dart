import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final Map<String, String> data;

  const ResultPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Data')), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: data.entries.map((entry) => ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value),
          )).toList(),
        ),
      ),
    );
  }
}