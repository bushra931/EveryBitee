import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalysisPage1 extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String analysisResult;

  const AnalysisPage1({
    super.key,
    required this.productData,
    required this.analysisResult,
  });

  Future<Map<String, dynamic>> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data() as Map<String, dynamic>;
    }
    return {};
  }

  String _generateNutriScore(
      double sugar, double fats, double proteins, String? pregnancyStatus) {
    String score;

    if (sugar > 10 || fats > 20) {
      score = "C";
    } else if (sugar > 5 || fats > 10) {
      score = "B";
    } else if (proteins >= 2) {
      score = "A";
    } else {
      score = "B";
    }

    if (pregnancyStatus == "Yes" || pregnancyStatus == "yes") {
      if (score == "B") {
        score = "C";
      } else if (score == "A") {
        score = "A";
      } else if (score == "C") {
        score = "D";
      }
    }

    return score;
  }

  String _generateEcoScore() {
    return "B";
  }

  double _scaleToTen(double value, double maxValue) {
    return (value / maxValue) * 10;
  }

  List<TextSpan> _parseMarkdownToSpans(String text) {
    final List<TextSpan> spans = [];
      final regex = RegExp(r'\*\*(.*?)\*\*');
      int startIndex = 0;

    for (final match in regex.allMatches(text)) {
      if (match.start > startIndex) {
        spans.add(TextSpan(text: text.substring(startIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(fontWeight: FontWeight.bold),
      ));
      startIndex = match.end;
    }

    if (startIndex < text.length) {
      spans.add(TextSpan(text: text.substring(startIndex)));
    }

    return spans;
  }

  Widget _buildEnvironmentalImpact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Environmental Impact:",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Eco-Score: A product's Eco-Score is based on its environmental impact, including factors such as production, transportation, and packaging. A higher score is better for the environment.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  "Nutri-Score: The Nutri-Score helps evaluate the nutritional quality of the product. A higher Nutri-Score indicates better nutritional quality.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  "Carbon Footprint: This product's carbon footprint measures the environmental cost of producing and transporting the product. A lower footprint is better for the environment.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 10),
                Text(
                  "Packaging: The packaging material affects the overall environmental impact. Sustainable and recyclable packaging is better for the planet.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching user data'));
        } else {
          var userData = snapshot.data ?? {};
          var pregnancyStatus = userData['pregnancy_status'];

          var productName = productData["product_name"] ?? "Unknown";
          var nutriments = productData["nutriments"] ?? {};

          var sugar = (nutriments["sugars"] ?? 0).toDouble();
          var proteins = (nutriments["proteins"] ?? 0).toDouble();
          var fats = (nutriments["fat"] ?? 0).toDouble();

          var nutriScore = productData["nutri_score"] ??
              _generateNutriScore(sugar, fats, proteins, pregnancyStatus);
          var ecoScore = productData["eco_score"] ?? _generateEcoScore();

          return Scaffold(
            appBar: AppBar(
              title: Text("Product Analysis"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.green[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "Nutri-Score",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  nutriScore,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Card(
                          color: Colors.blue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "Eco-Score",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ecoScore,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Personalised Analysis:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                          children: _parseMarkdownToSpans(analysisResult),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildEnvironmentalImpact(),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
