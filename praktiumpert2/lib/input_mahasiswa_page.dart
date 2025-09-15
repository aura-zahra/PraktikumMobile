import 'package:flutter/material.dart';
import 'package:praktikum2/models/mahasiswa.dart';

class InputMahasiswaPage extends StatefulWidget {
  const InputMahasiswaPage({super.key});

  @override
  State<InputMahasiswaPage> createState() => _InputMahasiswaPageState();
}

class _InputMahasiswaPageState extends State<InputMahasiswaPage> {
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kontakController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _umurController.dispose();
    _alamatController.dispose();
    _kontakController.dispose();
    super.dispose();
  }

  void _simpanData() {
    if (_namaController.text.isEmpty ||
        _umurController.text.isEmpty ||
        _alamatController.text.isEmpty ||
        _kontakController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field harus diisi!")),
      );
      return;
    }

    final mahasiswa = Mahasiswa(
      nama: _namaController.text,
      umur: int.tryParse(_umurController.text) ?? 0,
      alamat: _alamatController.text,
      kontak: _kontakController.text,
    );

    Navigator.pop(context, mahasiswa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Mahasiswa")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: _umurController,
              decoration: const InputDecoration(labelText: "Umur"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(labelText: "Alamat"),
            ),
            TextField(
              controller: _kontakController,
              decoration: const InputDecoration(labelText: "Kontak"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simpanData,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}