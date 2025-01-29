import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BarcodeAnalysisScreen extends StatefulWidget {
  final String barcode;
  const BarcodeAnalysisScreen({super.key, required this.barcode});

  @override
  _BarcodeAnalysisScreenState createState() => _BarcodeAnalysisScreenState();
}

class _BarcodeAnalysisScreenState extends State<BarcodeAnalysisScreen> {
  Map<String, dynamic>? productInfo;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(Uri.parse('http://your-server-ip:port/barcode/${widget.barcode}'));
      if (response.statusCode == 200) {
        setState(() {
          productInfo = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Failed to fetch product data.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error occurred: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Analysis")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : productInfo != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product: ${productInfo!['product_name']}",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Text("NutriScore: ${productInfo!['nutriscore']}"),
                      Text("EcoScore: ${productInfo!['ecoscore']}"),
                      // Display other product info here
                    ],
                  ),
                )
              : Center(child: Text(errorMessage)),
    );
  }
}
