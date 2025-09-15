import "package:flutter/material.dart";

class SecondPageWithData extends StatelessWidget {
  final String nama;
  final int umur;
  final String alamat;

  const SecondPageWithData({
    super.key,
    required this.nama,
    required this.umur,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Second Page with Data")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nama: $nama"),
            Text("Umur: $umur"),
            Text("Alamat: $alamat"),
          ],
        ),
      ),
    );
  }
}