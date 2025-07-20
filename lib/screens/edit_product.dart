import 'package:api_statemanagement/models/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product? product;

  EditProductScreen({this.product});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();
  final _categoryIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _titleController.text = widget.product!.title;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      _imageController.text = widget.product!.image;
      _categoryIdController.text = '1'; // Giả sử categoryId, có thể lấy từ product.category
    } else {
      _categoryIdController.text = '1'; // Mặc định categoryId là 1
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _imageController,
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
              ),
              TextFormField(
                controller: _categoryIdController,
                decoration: InputDecoration(labelText: 'Category ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter category ID' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final productData = {
                      'title': _titleController.text,
                      'price': double.parse(_priceController.text),
                      'description': _descriptionController.text,
                      'categoryId': int.parse(_categoryIdController.text),
                      'images': [_imageController.text],
                    };
                    if (widget.product == null) {
                      provider.createProduct(productData);
                    } else {
                      provider.updateProduct(widget.product!.id, productData);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.product == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}