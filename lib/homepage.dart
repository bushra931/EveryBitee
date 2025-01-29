import 'package:everybite/bottomnav.dart';
import 'package:everybite/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void navigateToHomePage(BuildContext context) {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => Homepage()),
    // );
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
      body: Column(
        children: [
          // Top Section
          Container(
            height: 300,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.lightGreen[200],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: Offset(0, 10), // Shadow direction
                ),
              ],
            ),
            child: Stack(
              children: [
                // Text in the left corner
                Positioned(
                  top: 35,
                  left: 20,
                  child: SizedBox(
                    width:
                        200, // Adjust width to control the text container size
                    child: Text(
                      "Unlock the power of nutrition with just a scan. Discover the real value of every product, right at your fingertips!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                // Scan button below the text
                Positioned(
                  top: 190, // Adjust position to appear below the text
                  left: 40,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add your scan action here
                    },
                    icon: Icon(Icons.qr_code_scanner),
                    label: Text("Scan Now"),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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

          // Middle Section with image and text
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
                  SizedBox(height: 20),
                  Text(
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
          // Bottom Navigation Bar
          CustomBottomNavBar(
            currentIndex: 0, // Profile Tab Index
            navigateToHomePage: () => navigateToHomePage(context),
            navigateToProfilePage: () => navigateToProfilePage(context),
          ),
        ],
      ),
    );
  }
}
