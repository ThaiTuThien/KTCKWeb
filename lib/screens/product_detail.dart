import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text('Error: ${provider.error}'));
          }
          final product = provider.productDetail;
          if (product == null) {
            return Center(child: Text('No product found'));
          }
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(product.image, height: 200),
                SizedBox(height: 16),
                Text(product.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('\$${product.price}', style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Text('Category: ${product.category}'),
                SizedBox(height: 16),
                Text(product.description),
              ],
            ),
          );
        },
      ),
    );
  }
}