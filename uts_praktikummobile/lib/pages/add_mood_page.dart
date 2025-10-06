import 'package:flutter/material.dart';
import '../models/mood_model.dart';
import '../services/shared_prefs_service.dart';

class AddMoodPage extends StatefulWidget {
  const AddMoodPage({Key? key}) : super(key: key);

  @override
  State<AddMoodPage> createState() => _AddMoodPageState();
}

class _AddMoodPageState extends State<AddMoodPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedMood;
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan Mood'),
        backgroundColor: const Color(0xFFA7C7E7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedMood,
                items: ['Bahagia', 'Sedih', 'Stres', 'Netral']
                    .map((mood) => DropdownMenuItem(
                          value: mood,
                          child: Text(mood),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMood = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Pilih Mood',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Mood harus dipilih' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Harian',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Catatan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newMood = Mood(
                      mood: _selectedMood!,
                      note: _noteController.text,
                      date: DateTime.now().toString(),
                    );
                    await SharedPrefsService.saveMood(newMood);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Catatan berhasil disimpan!')),
                    );
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}