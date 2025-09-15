import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mahasiswa',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _CounterPageState();
}

class _CounterPageState extends State<Homepage> {
  int count = 0;

  void increment () => setState(() => count++);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplikasi Mahasiswa')),
      body: Center(child: Text('Counter: $count')),
      floatingActionButton: FloatingActionButton(
        onPressed: increment,
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu Utama', 
                style: TextStyle(color: Colors.white, fontSize: 24)
                ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
    );
  }
}
//class Homepage extends StatelessWidget {
  //const Homepage({super.key});

  //@override
  //Widget build(BuildContext context) {
    //return Scaffold(
      //appBar: AppBar(title: const Text('Aplikasi Mahasiswa')),
      //body: const Center(
        //child: Text(
          //'Selamat Datang di Aplikasi Mahasiswa',
          //style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        //),
      //),
    //);
  //}
//}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Text(
//       'Hello, Aura!',
//       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//     );
//   }
// }