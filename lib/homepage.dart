import 'package:everybite/splashscreen1.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';


class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String scannedBarcode = "";

  Future<void> scanBarcode() async {
    // Request camera permission
    var status = await Permission.camera.request();

    if (status.isGranted) {
      try {
        var result = await BarcodeScanner.scan();
        if (result.rawContent.isNotEmpty) {
          // Vibrate on successful scan
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 500); // 500ms vibration
          }
          // Transition to splash screen while loading result
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SplashScreen(barcode: result.rawContent),
            ),
          );
        }
      } catch (e) {
        setState(() {
          scannedBarcode = "Failed to scan barcode: $e";
        });
      }
    } else {
      setState(() {
        scannedBarcode = "Camera permission denied!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Top Section
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
                  top: 35,
                  left: 20,
                  child: SizedBox(
                    width: 200,
                    child: Text(
                      "Unlock the power of nutrition with just a scan. Discover the real value of every product, right at your fingertips!",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 350,
                  left: 40,
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
                          horizontal: 30, vertical: 10),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -110,
                  right: 20,
                  child: Image.asset(
                    'assets/image/3.png', // Replace with your image path
                    height: 500,
                    width: 105,
                  ),
                ),
              ],
            ),
          ),

          // Display Scanned Barcode
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
                  const SizedBox(height: 20),
                  Text(
                    "Scan, Discover, Nourish!",
                    style: const TextStyle(
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
    );
  }
}
