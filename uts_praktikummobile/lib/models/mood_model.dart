class Mood {
  final String mood;
  final String note;
  final String date;

  Mood({required this.mood, required this.note, required this.date});

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'note': note,
        'date': date,
      };

  factory Mood.fromJson(Map<String, dynamic> json) => Mood(
        mood: json['mood'],
        note: json['note'],
        date: json['date'],
      );
}