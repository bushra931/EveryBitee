import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnalysisPage extends StatelessWidget {
  final Map<String, dynamic> productData;
  final String analysisResult;

  const AnalysisPage({
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
    // Example simple scoring rule: You can adjust this based on more refined logic
    String score;
    if (sugar > 10 || fats > 20) {
      score = "C";
    } else if (sugar > 5 || fats > 10) {
      score = "B";
    } else if (proteins >= 2) {
      score = "A";
    } else {
      score = "B"; // Default score
    }

    // Adjust score if pregnancy status is "Yes"
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

          // Extract relevant information from the product data
          var productName = productData["product_name"] ?? "Unknown";
          var nutriments = productData["nutriments"] ?? {};

          // Ensure that all nutritional data is in double format
          var sugar = (nutriments["sugars"] ?? 0).toDouble();
          var proteins = (nutriments["proteins"] ?? 0).toDouble();
          var fats = (nutriments["fat"] ?? 0).toDouble();
          var sodium = (nutriments["sodium"] ?? 0).toDouble();
          var iron = (nutriments["iron"] ?? 0).toDouble();

          // Get Nutri-Score and Eco-Score from the product data, or generate custom scores if not available
          var nutriScore = productData["nutri_score"] ??
              _generateNutriScore(sugar, fats, proteins, pregnancyStatus);
          var ecoScore = productData["eco_score"] ?? _generateEcoScore();

          // Max values to normalize to a scale of 10
          const maxValue = 100.0;

          List<TextSpan> _parseMarkdownToSpans(String text) {
            final List<TextSpan> spans = [];
            final regex = RegExp(
                r'\*\*(.*?)\*\*'); // Matches text between double asterisks
            int startIndex = 0;

            for (final match in regex.allMatches(text)) {
              // Add normal text before the bold part
              if (match.start > startIndex) {
                spans.add(
                    TextSpan(text: text.substring(startIndex, match.start)));
              }

              // Add bold text
              spans.add(TextSpan(
                text: match.group(1), // The text inside **
                style: TextStyle(fontWeight: FontWeight.bold),
              ));

              startIndex = match.end;
            }

            // Add remaining text after the last match
            if (startIndex < text.length) {
              spans.add(TextSpan(text: text.substring(startIndex)));
            }

            return spans;
          }

          // Data for the pie chart (scaled to 10)
          Map<String, double> pieChartData = {
            "Sugar": _scaleToTen(sugar, maxValue),
            "Proteins": _scaleToTen(proteins, maxValue),
            "Fats": _scaleToTen(fats, maxValue),
            "Sodium": _scaleToTen(sodium, maxValue),
            "Iron": _scaleToTen(iron, maxValue),
          };

          // Colors for the pie chart
          List<Color> pieChartColors = [
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.purple,
            Colors.red,
            Colors.blue,
          ];

          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Product Analysis",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.blueAccent,
            ),
            backgroundColor: Colors.grey[200],
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      "Product:",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      productName,
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                    ),
                    const SizedBox(height: 20),

                    // Nutritional values on a scale of 10
                    Text(
                      "Nutritional Value (Scale of 10):",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Pie Chart
                    PieChart(
                      dataMap: pieChartData,
                      colorList: pieChartColors,
                      chartRadius: MediaQuery.of(context).size.width / 3.2,
                      animationDuration: Duration(milliseconds: 800),
                      chartLegendSpacing: 32,
                      initialAngleInDegree: 0,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      centerText: "Nutrients",
                      legendOptions: LegendOptions(
                        showLegendsInRow: false,
                        legendPosition: LegendPosition.right,
                        showLegends: true,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      chartValuesOptions: ChartValuesOptions(
                        showChartValueBackground: true,
                        showChartValues: true,
                        showChartValuesInPercentage: false,
                        showChartValuesOutside: false,
                        decimalPlaces: 1,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nutri-Score and Eco-Score
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

                    // AI Analysis Section
                    Text(
                      "Personalised Analysis :",
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
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                            children: _parseMarkdownToSpans(analysisResult),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Environmental Impact Section
                    _buildEnvironmentalImpact(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Helper method to scale the values to a scale of 10
  double _scaleToTen(double value, double maxValue) {
    return (value / maxValue) * 10;
  }

  String _generateEcoScore() {
    // A simple placeholder logic for Eco-Score
    return "B"; // You can replace this with more complex logic
  }

  // Helper method to handle environmental impact information
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
}
