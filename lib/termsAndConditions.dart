import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.green.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 26, 122, 23)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16.0),
          color: Colors.green.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 77, 175, 81),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Welcome to EveryBite! These Terms and Conditions ('Terms') govern your use of the EveryBite mobile application and any associated services (collectively, the 'Service'). By accessing or using the Service, you agree to comply with and be bound by these Terms.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "1. Acceptance of Terms:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "By using EveryBite, you accept and agree to be bound by these Terms, along with our Privacy Policy. If you do not agree with these Terms, do not use the Service.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "2. Changes to Terms:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "We reserve the right to update or modify these Terms at any time. When we make changes, the updated Terms will be posted within the app or on our website. Continued use of the Service after changes have been made constitutes acceptance of the new Terms.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "3. User Registration:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "To access certain features of the Service, you may be required to create an account. You agree to provide accurate and complete information when registering and to update your information if necessary. You are responsible for maintaining the confidentiality of your account details and for all activities under your account.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "4. Use of the Service:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "You agree to use the Service in accordance with applicable laws and not to engage in any activity that may harm, disrupt, or interfere with the Service’s operations or security. You also agree not to misuse the barcode scanning feature or any other aspect of the app for fraudulent, misleading, or unlawful purposes.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "5. Nutritional Information:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "The Service provides nutritional information by scanning product barcodes. While we strive for accuracy, we cannot guarantee the complete accuracy, reliability, or completeness of the information provided. Nutritional values, ingredients, and other product data may vary by region, brand, or packaging.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "6. Privacy and Data Collection:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "Your use of the Service may involve the collection of personal data as described in our Privacy Policy. By using the Service, you consent to the collection and use of your data as outlined in the Privacy Policy.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "7. Limitation of Liability:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "The Service is provided 'as is' and 'as available' without warranties of any kind. We do not guarantee that the Service will be error-free, uninterrupted, or secure. To the fullest extent permitted by law, EveryBite is not responsible for any damages arising from the use or inability to use the Service.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                "8. Termination:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 39, 102, 41),
                ),
              ),
              const Text(
                "We reserve the right to suspend or terminate your access to the Service at any time, without notice, for any reason, including violations of these Terms. Upon termination, your right to use the Service will immediately cease.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
