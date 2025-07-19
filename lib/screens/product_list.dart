import 'package:api_statemanagement/screens/add_edit_product_screen.dart';
import 'package:api_statemanagement/screens/edit_product.dart';
import 'package:api_statemanagement/screens/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchProducts(); // Tải lần đầu

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !_scrollController.position.outOfRange &&
          !provider.isLoading &&
          provider.hasMore) {
        provider.fetchProducts(isLoadMore: true); // Tải thêm khi gần đến cuối
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts() async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.fetchProducts(); // Tải lại từ đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: RefreshIndicator(
        onRefresh: _refreshProducts, 
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading && provider.products.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ListTile(
                  leading: Image.network(
                    product.image ?? '',
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                  ),
                  title: Text(product.title ?? 'No Title'),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      provider.fetchProductDetail(product.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProductScreen(product: product)),
                      );
                    },
                  ),
                  onTap: () {
                    provider.fetchProductDetail(product.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProductDetailScreen()),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
     floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}