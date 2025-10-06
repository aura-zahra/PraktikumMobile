import 'package:flutter/material.dart';

void main() => runApp(BelajarBerita());

class BelajarBerita extends StatefulWidget {
  @override
  _BelajarBeritaState createState() => _BelajarBeritaState();
}

class _BelajarBeritaState extends State<BelajarBerita> {
  final List<Map<String, String>> berita = [
    {
      'thumbnail': 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1NwucW.img?w=750&h=500&m=6&x=120&y=120&s=280&d=280',
      'title': 'Mengapa Soeharto Tak Diculik Seperti Jenderal Lainnya Saat Peristiwa G30S?',
      'subtitle': 'Peristiwa Gerakan 30 September (G30S) menewaskan 9 perwira Tentara Nasional Indonesia Angkatan Darat (TNI AD) dan 1 anggota Kepolisian Negara Republik Indonesia (Polri).',
    },
    {
      'thumbnail': 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1NJg2V.img?w=750&h=500&m=6&x=120&y=120&s=280&d=280',
      'title': 'Menggagas Ulang Pendidikan di Era Akal Imitasi',
      'subtitle': 'Menjawab tantangan global yang semakin kompleks ini, Redea Institute menyelenggarakan Konferensi Internasional Redea (RIC) 2025 ke-15, mengangkat tema sentral "Menggagas Ulang Pendidikan di Era Digital" (2/10/2025).',
    },
    {
      'thumbnail': 'https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1NDbVx.img?w=612&h=344&m=6',
      'title': 'Pulang ke Rumah yang Dijarah,Kelakuan Uya Kuya Malah Banjir Kritik,Lita Gading: Publik Ini Marah',
      'subtitle': 'Kritikan muncul imbas konten yang diunggah Uya Kuya di kanal YouTube pribadinya saat ia dan istrinya Kuya kembali ke rumah yang beberapa waktu lalu sempat dijarah massa.',
    },
  ];

  final Set<int> _bookmarkedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Berita'),
        ),
        body: ListView.builder(
          itemCount: berita.length,
          itemBuilder: (context, index) {
            final item = berita[index];
            final isBookmarked = _bookmarkedIndexes.contains(index);
            return ListTile(
              leading: Image.network(
                item['thumbnail']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(item['title']!),
              subtitle: Text(item['subtitle']!),
              trailing: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: isBookmarked ? Colors.blue : null,
                ),
                onPressed: () {
                  setState(() {
                    if (isBookmarked) {
                      _bookmarkedIndexes.remove(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Berita "${item['title']}" dihapus dari bookmark')),
                      );
                    } else {
                      _bookmarkedIndexes.add(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Berita "${item['title']}" ditambahkan ke bookmark')),
                      );
                    }
                  });
                },
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mengalihkan ke halaman berita')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}