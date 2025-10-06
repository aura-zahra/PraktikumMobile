import 'package:flutter/material.dart';
import '../models/mood_model.dart';

class MoodCard extends StatelessWidget {
  final Mood mood;

  const MoodCard({Key? key, required this.mood}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Icon(
          mood.mood == 'Bahagia'
              ? Icons.sentiment_satisfied
              : mood.mood == 'Sedih'
                  ? Icons.sentiment_dissatisfied
                  : mood.mood == 'Stres'
                      ? Icons.sentiment_very_dissatisfied
                      : Icons.sentiment_neutral,
          color: Colors.blue,
        ),
        title: Text(mood.mood),
        subtitle: Text(mood.note),
        trailing: Text(mood.date.split(' ')[0]),
      ),
    );
  }
}