import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailScreenModern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Giả sử bạn truyền ID sản phẩm qua arguments
    // final productId = ModalRoute.of(context)!.settings.arguments as String;

    // Để chạy ví dụ này, chúng ta sẽ sử dụng provider trực tiếp
    final provider = Provider.of<ProductProvider>(context, listen: true);
    final product = provider.productDetail;

    return Scaffold(
      backgroundColor: Colors.white, // Nền trắng cho cảm giác sạch sẽ
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Colors.deepPurpleAccent));
          }
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, color: Colors.redAccent, size: 60),
                  SizedBox(height: 15),
                  Text(
                    'Failed to load product',
                    style: TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Error: ${provider.error}',
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }
          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, color: Colors.grey, size: 60),
                  SizedBox(height: 10),
                  Text('Product not found.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          // Giao diện chính khi có dữ liệu
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 350.0,
                pinned: true,
                floating: false,
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 8,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.favorite_border, color: Colors.white, size: 28),
                    onPressed: () {
                      // Logic thêm vào danh sách yêu thích
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: product.id, // Sử dụng tag duy nhất (ví dụ: product.id)
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.2), // Thêm lớp phủ mờ
                      colorBlendMode: BlendMode.darken,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator(color: Colors.white));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 100, color: Colors.grey[300]);
                      },
                    ),
                  ),
                  title: Text(
                    product.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên sản phẩm và giá
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.deepPurpleAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Phân loại
                        Chip(
                          label: Text(
                            product.category.toUpperCase(),
                            style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w600),
                          ),
                          backgroundColor: Colors.deepPurple.shade50,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                        ),
                        SizedBox(height: 24),

                        // Mô tả sản phẩm
                        Text(
                          'About this product',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5, // Tăng khoảng cách dòng để dễ đọc
                          ),
                        ),
                        SizedBox(height: 100), // Thêm khoảng trống để không bị che bởi footer
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      // Thanh hành động cố định ở dưới
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.shopping_cart_outlined, color: Colors.deepPurpleAccent),
                  label: Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added to Cart!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.deepPurpleAccent, width: 2),
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.flash_on, color: Colors.white),
                  label: Text('Buy Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Redirecting to checkout!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}