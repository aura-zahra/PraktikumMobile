import 'package:flutter/material.dart';
import 'models/mahasiswa.dart';

class DetailMahasiswaPage extends StatelessWidget {
  final Mahasiswa mhs;

  const DetailMahasiswaPage({super.key, required this.mhs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Mahasiswa")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nama: ${mhs.nama}"),
            Text("Umur: ${mhs.umur}"),
            Text("Alamat: ${mhs.alamat}"),
          ],
        ),
      ),
    );
  }
}