import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final List<String> orders = ['Order 1', 'Order 2', 'Order 3'];
  String selectedOrder = 'Order 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Container(
        color: Color(0xFFF8F8FF), // Background color
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple[100],
                child: Icon(Icons.camera_alt, size: 40, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildProfileItem('Nama Pengguna', 'Aura Zahra'),
                  _buildProfileItem('Jenjang Pendidikan', 'Mahasiswa'),
                  _buildProfileItem('Jurusan / Program Studi', 'Teknik Informatika'),
                  SizedBox(height: 20),
                  Text(
                    'Orderan yang sedang diproses:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedOrder,
                    isExpanded: true,
                    items: orders.map((String order) {
                      return DropdownMenuItem<String>(
                        value: order,
                        child: Text(order),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedOrder = newValue!;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(value, style: TextStyle(fontSize: 14)),
            ],
          ),
          Icon(Icons.edit, color: Colors.grey),
        ],
      ),
    );
  }
}