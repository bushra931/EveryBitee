import 'package:flutter/material.dart';

class BarcodeAnalysisScreen extends StatelessWidget {
  final Product product;

  const BarcodeAnalysisScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Analysis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product: ${product.name}', style: TextStyle(fontSize: 20)),
            Text('Nutri-Score: ${product.nutriscore}', style: TextStyle(fontSize: 16)),
            Text('Eco-Score: ${product.ecoscore}', style: TextStyle(fontSize: 16)),
            Text('Ingredients: ${product.ingredientsText}', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String barcode;
  final String nutriscore;
  final String ecoscore;
  final String ingredientsText;

  Product({
    required this.name,
    required this.barcode,
    required this.nutriscore,
    required this.ecoscore,
    required this.ingredientsText,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      barcode: json['barcode'],
      nutriscore: json['nutriscore'],
      ecoscore: json['ecoscore'],
      ingredientsText: json['ingredients_text'],
    );
  }
}
