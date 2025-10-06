import 'package:flutter/material.dart';
import 'add_mood_page.dart';
import '../widgets/mood_card.dart';
import '../models/mood_model.dart';
import '../services/shared_prefs_service.dart';

class MoodJournalPage extends StatefulWidget {
  const MoodJournalPage({Key? key}) : super(key: key);

  @override
  State<MoodJournalPage> createState() => _MoodJournalPageState();
}

class _MoodJournalPageState extends State<MoodJournalPage> {
  List<Mood> moodList = [];

  @override
  void initState() {
    super.initState();
    _loadMoodList();
  }

  Future<void> _loadMoodList() async {
    final loadedMoods = await SharedPrefsService.loadMoodList();
    setState(() {
      moodList = loadedMoods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MindCare – Mood Journal'),
        backgroundColor: const Color(0xFFA7C7E7),
      ),
      body: moodList.isEmpty
          ? const Center(child: Text('Belum ada catatan mood.'))
          : ListView.builder(
              itemCount: moodList.length,
              itemBuilder: (context, index) {
                return MoodCard(mood: moodList[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMoodPage()),
          );
          if (result == true) {
            _loadMoodList();
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFFB7E4C7),
      ),
    );
  }
}