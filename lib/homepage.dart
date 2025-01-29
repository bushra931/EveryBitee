<<<<<<< HEAD
import 'package:everybite/scannerscreen.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
=======
import 'package:flutter/material.dart';
>>>>>>> upstream/main
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
<<<<<<< HEAD
  String scannedBarcode = "";

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        navigateToAnalysisScreen(result.rawContent);
      }
    } catch (e) {
      setState(() {
        scannedBarcode = "Failed to scan barcode: $e";
      });
    }
  }

  void navigateToAnalysisScreen(String barcode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeAnalysisScreen(barcode: barcode),
      ),
    );
  }

=======
>>>>>>> upstream/main
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Top Section
          Container(
<<<<<<< HEAD
            height: MediaQuery.of(context).size.height /
                2, // Set height to half the screen
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              borderRadius: const BorderRadius.only(
=======
            height: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              borderRadius: BorderRadius.only(
>>>>>>> upstream/main
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 10,
<<<<<<< HEAD
                  offset: const Offset(0, 10), // Shadow direction
=======
                  offset: Offset(0, 10), // Shadow direction
>>>>>>> upstream/main
                ),
              ],
            ),
            child: Stack(
              children: [
                // Text in the left corner
<<<<<<< HEAD
                const Positioned(
                  top: 35,
                  left: 20,
                  child: SizedBox(
                    width: 200,
=======
                Positioned(
                  top: 35,
                  left: 20,
                  child: SizedBox(
                    width:
                        200, // Adjust width to control the text container size
>>>>>>> upstream/main
                    child: Text(
                      "Unlock the power of nutrition with just a scan. Discover the real value of every product, right at your fingertips!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
<<<<<<< HEAD
                        fontSize: 25,
=======
                        fontSize: 18,
>>>>>>> upstream/main
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                // Scan button below the text
                Positioned(
<<<<<<< HEAD
                  top: 350,
                  left: 40,
                  child: ElevatedButton.icon(
                    onPressed: scanBarcode,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text("Scan Now"),
=======
                  top: 190, // Adjust position to appear below the text
                  left: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add your scan action here
                    },
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text("Scan Now"),
>>>>>>> upstream/main
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
<<<<<<< HEAD
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
=======
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
>>>>>>> upstream/main
                    ),
                  ),
                ),
                // Image in the right corner
                Positioned(
                  bottom: -110,
                  right: 20,
                  child: Image.asset(
                    'assets/image/3.png', // Replace with your image path
                    height: 500, // Adjust image size
                    width: 105,
                  ),
                ),
              ],
            ),
          ),

<<<<<<< HEAD
          // Display Scanned Barcode
=======
          // Middle Section with image and text
>>>>>>> upstream/main
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/image/2.png', // Replace with your image path
                    width: 150,
                    height: 150,
                  ),
<<<<<<< HEAD
                  const SizedBox(height: 20),
                  Text(
                    "Scan, Discover, Nourish!",
                    style: const TextStyle(
=======
                  SizedBox(height: 20),
                  Text(
                    "Scan, Discover, Nourish!",
                    style: TextStyle(
>>>>>>> upstream/main
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
<<<<<<< HEAD

          // Bottom Navigation Bar
          BottomNavigationBar(
            items: const [
=======
          // Bottom Navigation Bar
          BottomNavigationBar(
            items: [
>>>>>>> upstream/main
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.eco),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ],
      ),
    );
  }
}
