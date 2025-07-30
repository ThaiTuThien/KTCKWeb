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
      _categoryIdController.text = '1'; // giả định
    } else {
      _categoryIdController.text = '1';
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product Details"),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: _inputDecoration('Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: _inputDecoration('Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('Description'),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: _inputDecoration('Image URL'),
                validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _categoryIdController,
                decoration: _inputDecoration('Category ID'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter category ID' : null,
              ),
              SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
                    child: Text(
                      widget.product == null ? 'Add Product' : 'Update Product',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
