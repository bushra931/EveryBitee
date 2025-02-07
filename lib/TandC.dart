import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.green), // Arrow color set to green
          onPressed: () {
            Navigator.pop(
                context); // This will navigate back to the previous page
          },
        ),
        backgroundColor: Colors.white, // AppBar background set to white
        elevation: 0, // Removes the shadow below the app bar
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "TERMS & CONDITIONS",
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 97, 190, 10),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to EveryBite! These Terms and Conditions ('Terms') govern your use of the EveryBite mobile application and any associated services (collectively, the 'Service'). By accessing or using the Service, you agree to comply with and be bound by these Terms.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              "1. Acceptance of Terms:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "By using EveryBite, you accept and agree to be bound by these Terms, along with our Privacy Policy. If you do not agree with these Terms, do not use the Service.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "2. Changes to Terms:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "We reserve the right to update or modify these Terms at any time. When we make changes, the updated Terms will be posted within the app or on our website. Continued use of the Service after changes have been made constitutes acceptance of the new Terms.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "3. User Registration:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "To access certain features of the Service, you may be required to create an account. You agree to provide accurate and complete information when registering and to update your information if necessary. You are responsible for maintaining the confidentiality of your account details and for all activities under your account.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "4. Use of the Service:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "You agree to use the Service in accordance with applicable laws and not to engage in any activity that may harm, disrupt, or interfere with the Service’s operations or security. You also agree not to misuse the barcode scanning feature or any other aspect of the app for fraudulent, misleading, or unlawful purposes.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "5. Nutritional Information:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "The Service provides nutritional information by scanning product barcodes. While we strive for accuracy, we cannot guarantee the complete accuracy, reliability, or completeness of the information provided. Nutritional values, ingredients, and other product data may vary by region, brand, or packaging.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "6. Privacy and Data Collection:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "Your use of the Service may involve the collection of personal data as described in our Privacy Policy. By using the Service, you consent to the collection and use of your data as outlined in the Privacy Policy.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "7. Limitation of Liability:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "The Service is provided 'as is' and 'as available' without warranties of any kind. We do not guarantee that the Service will be error-free, uninterrupted, or secure. To the fullest extent permitted by law, EveryBite is not responsible for any damages arising from the use or inability to use the Service.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "8. Termination:",
              style: TextStyle(color: Color.fromARGB(255, 60, 112, 0)),
            ),
            Text(
              "We reserve the right to suspend or terminate your access to the Service at any time, without notice, for any reason, including violations of these Terms. Upon termination, your right to use the Service will immediately cease.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
