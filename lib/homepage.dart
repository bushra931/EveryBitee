import 'package:everybite/ai/ai_controller.dart';
import 'package:everybite/ai/apiBarcode.dart';
import 'package:everybite/bottomnav.dart';
import 'package:everybite/profilepage.dart';
import 'package:everybite/scanningpage.dart';
import 'package:everybite/splashscreen1.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

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
  submitForm(String prompt, String sourcePage) async {
    await storage.read('allergies') == ""
        ? await storage.write('allergies', 'None')
        : null;
    await storage.read('medicalConditions') == ""
        ? await storage.write('medicalConditions', 'None')
        : null;
    print(prompt);
    Get.put(AiController()).productName = prompt;
    print('${Get.put(AiController()).productName}');
    print('${storage.read('language')}');
    print('printed');

    if (storage.read('gender') == 'Male' ||
        storage.read('gender') == 'Select' ||
        (storage.read('gender') == 'Female' &&
            !storage.read('isPregnantOrLactating'))) {
      if (sourcePage == 'manual') {
        finalPrompt = '''The product name of a packaged food is - ${prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

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
Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption or not. Answer in yes or no and for the answer give a suitable reasoning.Give your response in ${storage.read('language')} language''';
      } else if (sourcePage == 'ocr') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

 give a separate paragraph for telling the user if the product is fit for consumption for the user
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
.''';
      } else if (sourcePage == 'barcode') {
        finalPrompt =
            '''A packed food product contains the following ingredients and information:
${prompt}
The name of the is - ${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption or not.
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do no mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
.''';
      }
    } else {
      if (sourcePage == 'manual') {
        print('manual');
        finalPrompt = '''
      The product name of a packaged food is - ${prompt}
Using the product name, retrieve the information about the ingredients, nutritional values, the material of their packaging, nutriscore, ecoscore, health hazards which may be associated to it, carbon footprint

The consumer is a ${storage.read('pregnancy_status') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')} and has a dietary preference of ${storage.read('dietary_preference')}.The user is a ${storage.read('dietary_preference')}.

Give me a detailed analysis by firstly showing the main components and nutritional values of the product, for example, state the values of sugar, proteins, etc. 
Then, give a separate paragraph for telling the user if the product is fit for consumption for a pregnant woman. 
Use the values of sodium and iron from the above information and compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and nutriscore, describe what does the score stand for. 
Also, use the carbon footprint to give a conclusion if the product is environmentally friendly or not. 
Also, use the packaging material to draw out the results.
Please use markdown to format the response.
Give me a response which considers all the parameters above and generate a final report stating your opinion if the product is fit for consumption for pregnant women or not. Answer in yes or no and for the answer give a suitable reasoning.
Use markdown in your response.''';
      } else if (sourcePage == 'ocr') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}

The consumer is a ${storage.read('pregnancy_status') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietaryPreference')}.The user is a ${storage.read('dietaryPreference')}.

  give a separate paragraph for telling the user if the product is fit for consumption for the user. 
If the product contains sodium and iron,  compare them with the adequate consumption of these minerals while stating if the values are fit or not. 
Furthermore, write about the cons and pros of the product by analyzing the information and the ingredients of the product. 

Write the whole response for an app page where the information is presented to the user. Write in a descriptive and informative tone. 
Also, give a personalized response based on the allergies and medical conditions inputted above. 
Adding to it, if there is a con in the product and if any ingredient is not adequate, give the possible health hazard related to it. 

Then, in a separate paragraph, give the information about the environmental aspect of the product like give the meaning to the ecoscore and 
Please use markdown to format the response.

At last give me a conclusion in which discuss whether the product is fit for consumption . Give a direct answer in yes or a no. and give reasoning for the answer you wish to output. Considor all the parameters and the harms and benfits of each ingredient listed and then draw out a reliable result
Use markdown in your response.''';
      } else if (sourcePage == 'barcode') {
        finalPrompt = '''
A packed food product contains the following ingredients and information:
${prompt}
If the ingredients are not listed, please use the name of the product to carry out the whole analysis.
Retrive the information for the desired information about the product from the product name 

The consumer is a ${storage.read('pregnancy_status') ? 'pregnant' : ''} ${storage.read('gender')} who has an age of ${storage.read('age')}. 
The user is also allergic to ${storage.read('allergies')}. and has a dietary preference of ${storage.read('dietary_preference')}.The user is a ${storage.read('dietaryPreference')}.

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
If some information is not provided, dont write that the information is not provided rather just skip the part and dont emphasise on it. Only write on the analysis on the given information and do not mention about an information which is not provided. For example if nutriscore is not present, dont write about it rather move on to the next parameter.
Use markdown in your response.''';
      }
    }
  }

  String? prompt;
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
                Positioned(
                  top: 260,
                  left: 20,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      String barcodeScanRes =
                          await FlutterBarcodeScanner.scanBarcode(
                              "#ff6666",
                              "Cancel",
                              false,
                              ScanMode.DEFAULT,
                              1, // Delay of 2000 milliseconds before scanning starts
                              "back", // Use the back camera
                              ScanFormat.ONLY_BARCODE // Scan for barcode format
                              );

                      if (barcodeScanRes != null) {
                        SplashScreen(); // Call your splash screen instead
                        prompt = await getProductDetails(barcodeScanRes);

                        try {
                          if (prompt!.isNotEmpty) {
                            submitForm(prompt!, 'barcode');
                          } else {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: ScanningPage(),
                              withNavBar: false,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          }
                        } catch (e) {
                          SplashScreen(); // Show splash screen on error as well
                        }
                      }
                    },
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
