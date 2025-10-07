import 'package:flutter/material.dart';

class CatalogPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Product 1', 'description': 'Description 1', 'price': 10000},
    {'name': 'Product 2', 'description': 'Description 2', 'price': 20000},
    {'name': 'Product 3', 'description': 'Description 3', 'price': 30000},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catalog')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text('${product['description']} - Rp ${product['price']}'),
              trailing: IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  // Tambahkan ke keranjang
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product['name']} added to cart')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}