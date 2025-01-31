import 'package:everybite/ai/ai_controller.dart';
import 'package:everybite/ai/apiBarcode.dart';
import 'package:everybite/ai/report.dart';
import 'package:everybite/common/widgets.dart';

import 'package:everybite/scanningpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
// Import the BarcodeAnalysisScreen
import 'package:everybite/ai/apiBarcode.dart'; // Import the API file
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class Homepage extends StatefulWidget {
  final String userId;
  const Homepage({super.key, required this.userId});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String scannedBarcode = "";

  @override
  void dispose() {
    super.dispose();
  }

  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  bool isLoaded = false;

  String finalPrompt = '';
  final storage = GetStorage();

  void _showSplashAndNavigate() {
    // Show splash screen for 1 second
    Future.delayed(Duration(seconds: 1), () {
      print("hpgyaaaaaaaa");
      Get.to(ReportPage(prompt: finalPrompt));
    });
  }

  submitForm(String prompt, String sourcePage) async {
    await storage.read('allergies') == ""
        ? await storage.write('allergies', 'None')
        : null;
    await storage.read('medicalConditions') == ""
        ? await storage.write('medicalConditions', 'None')
        : null;

    Get.put(AiController()).productName = prompt;

    if (storage.read('gender') == 'Male' ||
        storage.read('gender') == 'Select' ||
        (storage.read('gender') == 'Female' &&
            !storage.read('isPregnantOrLactating'))) {
      if (sourcePage == 'manual') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      } else if (sourcePage == 'ocr') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      } else if (sourcePage == 'barcode') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      }
    } else {
      if (sourcePage == 'manual') {
        print('manual');
        finalPrompt = '''
      A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      } else if (sourcePage == 'ocr') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      } else if (sourcePage == 'barcode') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrieve the information for the desired information about the product from the product name.

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, don't write that the information is not provided rather just skip the part and don't emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, don't write about it rather move on to the next parameter.''';
      }
    }
    _showSplashAndNavigate();
  }

  String? prompt;

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
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF9E9BC7),
                      borderRadius: BorderRadius.circular(32)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    child: Row(children: [
                      SizedBox(
                        width: 138,
                        child: Text(
                          "Scan Barcodes directly here",
                          style: GoogleFonts.signika(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ZoomTapAnimation(
                        onTap: () async {
                          String barcodeScanRes =
                              await FlutterBarcodeScanner.scanBarcode(
                                  "#ff6666",
                                  "Cancel",
                                  false,
                                  ScanMode.DEFAULT,
                                  1,
                                  "back",
                                  ScanFormat.ONLY_BARCODE);

                          CommonWidgets.showToast("Searching...");
                          if (barcodeScanRes != null) {
                            prompt = await getProductDetails(barcodeScanRes);
                            // Navigator.pop(context);
                            // print(prompt);
                            try {
                              if (prompt != null && prompt!.isNotEmpty) {
                                submitForm(prompt!, 'barcode');
                              } else {
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: ReportPage(
                                    prompt: finalPrompt,
                                  ), // Yahan par ScanningPage ki jagah ReportPage daalna hoga
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              }
                            } catch (e) {
                              CommonWidgets.showToast(
                                  "Product not found. Error: ${e.toString()}");
                            }
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(children: [
                              Image.asset("assets/image/qr_icon.png"),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                "Scan Now",
                                style: GoogleFonts.signika(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Color(0xFF9E9BC7),
                                ),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ]),
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
    );
  }
}
