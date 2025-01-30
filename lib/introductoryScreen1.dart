import 'package:flutter/material.dart';
import 'introductoryScreen2.dart';

class IntroScreenOne extends StatefulWidget {
  final String userId;
  const IntroScreenOne({super.key, required this.userId});

  @override
  State<IntroScreenOne> createState() => _IntroScreenOneState();
}

class _IntroScreenOneState extends State<IntroScreenOne> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const IntroScreenTwo()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 232,
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 36),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFFA6FF4E), Color(0xFFEFF1B3)],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 210,
                height: 230,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/210x230"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const SizedBox(
                width: 149,
                child: Text(
                  'The ancient Mayans and Aztecs used cacao beans as money.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Istok Web',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.90,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

