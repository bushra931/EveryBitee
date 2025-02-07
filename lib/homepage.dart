import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:everybite/analysispage.dart';
import 'package:everybite/profilepage.dart';
import 'package:everybite/bottomnav.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String scannedBarcode = "";
  bool _isLoading = false;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        scannedBarcode = result.rawContent;
      });

      if (scannedBarcode.isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        await fetchProductDetails(scannedBarcode);
      }
    } catch (e) {
      print("Error scanning barcode: $e");
    }
  }

  Future<void> fetchProductDetails(String barcode) async {
    final url = "https://world.openfoodfacts.org/api/v0/product/$barcode.json";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == 1) {
        final product = data["product"];
        await analyzeFood(product);
      } else {
        print("Product not found");
      }
    } else {
      print("Failed to fetch product data");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> analyzeFood(Map<String, dynamic> product) async {
    // const apiKey = "AIzaSyBFfJrN7Bq6ilr7ep_NTtFSI6s_cJMvBWg";
    const apiKey = "";
    final model = GenerativeModel(apiKey: apiKey, model: "gemini-pro");

    String userDetails = "";
    if (userData != null) {
      userDetails = """
User Details:
- Name: ${userData!['full_name']}
- Age: ${userData!['age']}
- Gender: ${userData!['gender']}
- Dietary Preference: ${userData!['dietary_preference']}
- Allergies: ${userData!['allergies']}
- Pregnancy Status: ${userData!['pregnancy_status']}
""";
    }

    final prompt = """
$userDetails

Analyze the following food product:
Name: ${product["product_name"] ?? "Unknown"}
Ingredients: ${product["ingredients_text"] ?? "No ingredients listed"}
Nutritional Info: ${product["nutriments"] ?? "No data available"}

Main Components and Nutritional Values:
Here is a detailed breakdown of the nutritional values:
Sugar: ${product["nutriments"]?["sugars"] ?? "Not available"}
Proteins: ${product["nutriments"]?["proteins"] ?? "Not available"}
Fats: ${product["nutriments"]?["fat"] ?? "Not available"}
Sodium: ${product["nutriments"]?["sodium"] ?? "Not available"}
Iron: ${product["nutriments"]?["iron"] ?? "Not available"}

Is the Product Fit for Consumption?
Based on the nutritional values of the product, here is an assessment of its suitability for consumption:

Sodium and Iron Analysis:
Sodium: The recommended daily intake of sodium for an average adult is around 2,300 mg. If the product's sodium content exceeds this, it may contribute to high blood pressure or heart disease.
Iron: The recommended daily intake for iron is 8 mg for men and 18 mg for women. Check if the product meets the necessary requirement. If it's low, the product may not be ideal for individuals needing more iron in their diet.

Pros and Cons:
Pros: Provide health benefits based on the ingredients like high protein or antioxidants.
Cons: Mention potential risks like allergens or high sugar content.

Personalized Response Based on Allergies or Medical Conditions:
If the product contains allergens or medically relevant ingredients, provide advice, such as gluten or excessive sodium intake risks.

Environmental Aspect:
Eco-Score: Evaluate the environmental impact based on production, transportation, and packaging.
Nutri-Score: Generate an estimation from A to F based on key nutritional aspects.

Carbon Footprint and Packaging:
Discuss the carbon footprint and packaging sustainability.

Conclusion:
Summarize whether the product is a good choice based on its nutritional values, potential health risks, and environmental considerations.

Generate the response in plain text without using any bold, bullets, or special symbols.
do not use special formats for heading

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption . 
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con Fin the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);

      if (response.text != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisPage(
              productData: product,
              analysisResult: response.text!,
            ),
          ),
        );
      }
    } catch (e) {
      print("Error generating AI analysis: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToProfilePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 80,
                      left: 20,
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          "Unlock the power of nutrition with just a scan. Discover the real value of every product, right at your fingertips!",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -60,
                      right: 50,
                      child: Image.asset(
                        'assets/image/wrap.png', // Replace with your image path
                        height: 500,
                        width: 105,
                      ),
                    ),
                    Positioned(
                      top: 330,
                      left: 20,
                      child: ElevatedButton.icon(
                        onPressed: scanBarcode,
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text("Scan Now"),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/image/corn.png', // Replace with your image path
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Scan, Discover, Nourish!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(), // Loading spinner
                  SizedBox(height: 20), // Spacing between spinner and text
                  Text(
                    'Generating your personalized response...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // Set index as 0 or any other depending on your needs
        navigateToHomePage:
            () {}, // You can modify the Home page navigation logic here
        navigateToProfilePage: () => navigateToProfilePage(context),
      ),
    );
  }
}
