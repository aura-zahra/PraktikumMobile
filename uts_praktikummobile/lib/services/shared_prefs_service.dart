import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mood_model.dart';

class SharedPrefsService {
  static const _moodListKey = 'moodList';

  static Future<void> saveMood(Mood mood) async {
    final prefs = await SharedPreferences.getInstance();
    final moodList = await loadMoodList();
    moodList.add(mood);
    final moodListJson =
        jsonEncode(moodList.map((m) => m.toJson()).toList());
    await prefs.setString(_moodListKey, moodListJson);
  }

  static Future<List<Mood>> loadMoodList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_moodListKey);
    if (data == null) return [];
    return (jsonDecode(data) as List)
        .map((json) => Mood.fromJson(json))
        .toList();
  }
}