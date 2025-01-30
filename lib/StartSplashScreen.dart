import 'package:flutter/material.dart';
import 'package:everybite/loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    const int totalDuration = 2000; // 2 seconds
    const int updateInterval = 20;  // Update every 20ms
    const double increment = updateInterval / totalDuration;

    Future.delayed(const Duration(milliseconds: updateInterval), () {
      if (mounted && progressValue < 1.0) {
        setState(() {
          progressValue += increment;
        });
        _startProgress();
      } else {
        _navigateToLoginPage();
      }
    });
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1FF72),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo.png',
              width: 250, // Large logo size
              height: 250,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
