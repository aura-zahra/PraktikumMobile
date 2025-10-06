import 'package:flutter/material.dart';
import 'pages/mood_journal_page.dart';

void main() {
  runApp(const MindCareApp());
}

class MindCareApp extends StatelessWidget {
  const MindCareApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MindCare',
      theme: ThemeData(
        primaryColor: const Color(0xFFA7C7E7),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFB7E4C7)),
        fontFamily: 'Poppins',
      ),
      home: const MoodJournalPage(),
    );
  }
}