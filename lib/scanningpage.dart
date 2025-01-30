import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_area_ocr_flutter/focused_area_ocr_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:everybite/homepage.dart';

class ScanningPage extends StatefulWidget {
  const ScanningPage({Key? key}) : super(key: key);

  @override
  _ScanningPageState createState() => _ScanningPageState();
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}

class _ScanningPageState extends State<ScanningPage> {
  final storage = GetStorage();
  final StreamController<String> controller = StreamController<String>();
  final double _textViewHeight = 80.0;
  TextEditingController _productNameController = TextEditingController();
  String scannedText = "";
  List<String> textList = [];

  void setText(value) {
    scannedText = value;
  }

  void updateText(String newText) {
    setState(() {
      scannedText = newText;
    });
  }

  // _scanIngredientsWithOCR() {
  //   setState(() {});

  //   print(scannedText);
  //   if (scannedText.isNotEmpty) {
  //     _HomepageState().submitForm(''' ${scannedText})}''', 'ocr');
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('No text found'),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    final Offset focusedAreaCenter = Offset(
      0,
      (statusBarHeight + kToolbarHeight) / 2,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.blue),
        title: const Text('Scan the Product'),
      ),
      
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      child: FocusedAreaOCRView(
                        focusedAreaHeight: 250,
                        focusedAreaWidth: 300,
                        onScanText: (text) {
                          controller.add(text);
                          textList.add(text);
                          scannedText = text;

                          print(scannedText);
                        },
                        focusedAreaCenter: focusedAreaCenter,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
