// import 'package:everybite/ai/ai_controller.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:googleai_dart/googleai_dart.dart';

// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:pie_chart/pie_chart.dart';


// class ReportPage extends StatefulWidget {
//   final String prompt;

//   const ReportPage({super.key, required this.prompt});
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ReportPage> {
//   final storage = GetStorage();
//   @override
//   initState() {
//     super.initState();
//     storage.write('isFormFilled', true);
//     sendMessage();
//   }

//   bool isComp = false;

//   List<Map<String, dynamic>> messages = [];

//   final client = GoogleAIClient(
//     // apiKey: gK,
//   );

//   @override
//   Widget build(BuildContext context) {
//     print('start');
//     print({messages.last['text']});
//     print('over');
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         // Get.offAll(
//         //   () => BottomNav(),
//         // );
//       },
//       child: Scaffold(
//         // backgroundColor: Color(0xfffff5d7),
//         backgroundColor: Color(0xFFB5B1E7),
//         appBar: AppBar(
//           backgroundColor: Color(0xFFB5B1E7),
//           centerTitle: true,
//           // backgroundColor: priColor,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             color: Colors.white,
//             onPressed: () {
//               // Get.offAll(
//               //   () => BottomNav(),
//               // );
//               // PersistentNavBarNavigator.pushNewScreen(
//               //   context,
//               //   screen: HomePage(),
//               //   withNavBar: true, // OPTIONAL VALUE. True by default.
//               //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
//               // );
//               // sendMessage2();
//               // sendMessage3();
//             },
//             icon: Icon(
//               Icons.arrow_back,
//             ),
//           ),
//           systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.pink),
//           title: Text('Analysis Report',
//               style: GoogleFonts.signika(
//                   fontWeight: FontWeight.w400,
//                   fontSize: 18.sp,
//                   color: Colors.white)),
//         ),
//         body: isComp
//             ? Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     // begin: Alignment.topLeft,
//                     // end: Alignment.bottomRight,
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color(0xFFB5B1E7),

//                       Color(0xFFFFF8EB),

//                       // Color(0xFFF6AEA3),
//                       // Color(0xFF91c788),

//                       Color(0xFF91C788),
//                       Colors.white,
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 10.h,
//                     ),
                    
//                     Text(
//                       "Nutrition composition on scale of 10",
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.signika(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.h,
//                     ),
//                     PieChart(
//                       dataMap: Get.put(AiController()).dataMap,
//                       animationDuration: Duration(milliseconds: 800),
//                       chartLegendSpacing: 32,
//                       chartRadius: MediaQuery.of(context).size.width / 3.2,
//                       colorList: [
//                         Colors.orange,
//                         Colors.yellow,
//                         Colors.green,
//                         Colors.purple,
//                         Colors.red,
//                         Colors.blue,
//                       ],
//                       initialAngleInDegree: 0,
//                       chartType: ChartType.ring,
//                       ringStrokeWidth: 32,
//                       centerText: "Nutrients",
//                       legendOptions: LegendOptions(
//                         showLegendsInRow: false,
//                         legendPosition: LegendPosition.right,
//                         showLegends: true,
//                         // legendShape: _BoxShape.circle,
//                         legendTextStyle: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       chartValuesOptions: ChartValuesOptions(
//                         showChartValueBackground: true,
//                         showChartValues: true,
//                         showChartValuesInPercentage: false,
//                         showChartValuesOutside: false,
//                         decimalPlaces: 1,
//                       ),
//                       // gradientList: ---To add gradient colors---
//                       // emptyColorGradient: ---Empty Color gradient---
//                     ),
//                     SizedBox(
//                       height: 40.h,
//                     ),
//                     Expanded(
//                       child: Container(
//                           // height: 1.sh,
//                           child: Markdown(
//                         shrinkWrap: true,
//                         data: '${messages.last['text']}',
//                         styleSheet: MarkdownStyleSheet(
//                           h1: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.grey.shade600), //top
//                           h2: TextStyle(
//                             fontSize: 18.sp,
//                             color: Colors.black,
//                           ), //na
//                           h3: TextStyle(
//                               fontSize: 27, color: Color(0xff2a2836)), //na
//                           h4: TextStyle(
//                             fontSize: 18,
//                           ), //na
//                           h5: TextStyle(
//                             fontSize: 17,
//                           ), //na
//                           p: TextStyle(
//                             fontSize: 15.sp,
//                             color: Color(0xFF4D4B4B),
//                           ), //details
//                           blockquote: TextStyle(
//                             fontSize: 14,
//                           ),
//                           code: TextStyle(
//                             fontSize: 14,
//                           ),
//                           em: TextStyle(
//                             fontSize: 14,
//                           ),
//                           strong: TextStyle(
//                             fontSize: 16.sp,
//                             color: Colors.black,
//                           ), // para headings
//                         ),
//                       )),
//                     ),
//                   ],
//                 ),
//               )
//             : isErr
//                 ? Center(
//                     child: Text('Something went wrong! Please try again.'),
//                   )
//                 : Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         // begin: Alignment.topLeft,
//                         // end: Alignment.bottomRight,
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Color(0xFFB5B1E7),

//                           Color(0xFFFFF8EB),

//                           // Color(0xFFF6AEA3),
//                           // Color(0xFF91c788),

//                           Color(0xFF91C788),
//                           Colors.white,
//                         ],
//                       ),
//                     ),
//                     height: MediaQuery.of(context).size.height,
//                     child: Center(
//                         child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Generating your report...',
//                         ),
//                         SizedBox(height: 10),
//                         // CircularProgressIndicator(
//                         //   strokeCap: StrokeCap.round,
//                         // ),
//                         SpinKitCircle(
//                           color: Color(0xFF91C788),
//                         )
//                       ],
//                     )),
//                   ),
//       ),
//     );
//   }

//   bool isErr = false;

  

//   void sendMessage() async {
//     final aiController = Get.put(AiController());
//     try {
//       //for report
//       String userMessage = widget.prompt;
//       setState(() {
//         messages.add({'text': userMessage, 'isUser': true});
//       });
//       // _controller.clear();

//       String modelResponse = await generateModelResponse(userMessage);
//       print(modelResponse);

// //for piechart
//       String userMessage2 =
//           '''The name of product is ${aiController.productName}. I want to know the nutrition values for Carbohydrates, Fat, Protein, Sodium, Sugar, and Fiber. It should be in scale of 10. Your response should be in this format:

// [3 ,2 ,1 ,1, 2 ,1]

// Here, the digits represent the nutrition values Carbohydrates, Fat, Protein, Sodium, Sugar, and Fiber respectively. Your response should only include this list, nothing else, not even any explanation.''';
//       String modelResponse2 = await generateModelResponse(userMessage2);
//       List<double> valuesList = convertToDoubleList(modelResponse2);
//       Get.put(AiController()).dataMap.updateAll((key, value) => valuesList[
//           Get.put(AiController()).dataMap.keys.toList().indexOf(key)]);
//       print(modelResponse2);
//       print("${aiController.dataMap}");
//       print('this');

//       //for emoji
//       String userMessage3 =
//           '''The name of product is ${aiController.productName}. I want you to provide me response of only digit -0, 1 or 2. Give me response 0 if the product is bad for our health. Give me response 1 if its okay to have sometimes in moderation. Give me 2 if its healthy. The response should only be 0 1 or 2.''';
// //           '''The name of product is maggie, I need you to provide me response of only digit - 0, 1 or 2.

// // Give me respone 0 if the product is bad for our health.
// // Give me 1 if its okay to have sometimes if in moderation.
// // Give me 2 if its healthy.

// // The response should only be 0 1 or 2.''';
//       print(userMessage3);
//       print('opk');
//       String modelResponse3 = await generateModelResponse(userMessage3);
//       print(modelResponse3);
//       aiController.rating = modelResponse3;
//       print(aiController.rating);
//       print(modelResponse3);
//       print("${aiController.rating}");
//       print("DONE");
//       setState(() {
//         messages.add({'text': modelResponse, 'isUser': false});
//         isComp = true;
//       });
//     } catch (e) {
//       print(e);
//       setState(() {
//         isErr = true;
//       });
//       // TODO
//     }
//   }

//   List<double> convertToDoubleList(String string) {
//     try {
//       // Remove square brackets from the string
//       String numbersString = string.substring(1, string.length - 1);

//       // Split the string by comma delimiter
//       List<String> stringList = numbersString.split(",");

//       // Convert each string element to double and return the list
//       return stringList.map((numString) => double.parse(numString)).toList();
//     } catch (e) {
//       // Handle potential exceptions during conversion (optional)
//       print("Invalid string format: $e");
//       return []; // Or throw an error based on your needs
//     }
//   }

//   Future<String> generateModelResponse(String userMessage) async {
//     // Send user message to AI model
//     final res = await client.generateContent(
//       modelId: 'gemini-pro',
//       request: GenerateContentRequest(
//         contents: [
//           Content(
//             role: 'user',
//             parts: [
//               Part(
//                 text: userMessage,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//     print(res);
//     print('ok');

//     // Get model's response
//     String response = res.candidates?.first.content?.parts?.first.text ??
//         "No response from the model.";
//     return response;
//   }
// }
