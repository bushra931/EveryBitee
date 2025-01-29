import 'package:everybite/scannerscreen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class SplashScreen extends StatelessWidget {
  final String barcode;

  const SplashScreen({Key? key, required this.barcode}) : super(key: key);

  Future<void> navigateToAnalysisScreen(
      BuildContext context, String barcode) async {
    final product = await fetchProduct(barcode);
    // After the result is ready, navigate to the analysis screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeAnalysisScreen(product: product),
      ),
    );
  }

  Future<Product> fetchProduct(String barcode) async {
    final response = await http.post(
      Uri.parse('http://localhost:8000/get_product/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'barcode': barcode}),
    );

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while data is being fetched
    navigateToAnalysisScreen(context, barcode);

    return Scaffold(
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset(
              'assets/image/burger.png', // Path to your burger image
              height: 100,  // Adjust the size as needed
              width: 100,
            ),
            const SizedBox(height: 20), // Space between the image and loader
            CircularProgressIndicator(),  // Loading spinner
          ],
        ),
      ),
    );
  }
}
