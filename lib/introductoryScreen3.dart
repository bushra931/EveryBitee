import 'package:flutter/material.dart';
import 'package:everybite/homepage.dart';

class IntroScreenThree extends StatefulWidget {
  const IntroScreenThree({Key? key}) : super(key: key);

  @override
  State<IntroScreenThree> createState() => _IntroScreenThreeState();
}

class _IntroScreenThreeState extends State<IntroScreenThree> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.of(context).pushReplacement(
      //      MaterialPageRoute(
      //      builder: (context) => Homepage(userId: user.uid),
      //     ),
      //   );
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
          padding: const EdgeInsets.only(top: 37, bottom: 26),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFFA6FF4E), Color(0xFFEFF1B3)],
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 171,
                child: Text(
                  'Capsicum triggers sweat, which cools your body as it evaporates.',
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
              const SizedBox(height: 15),
              Container(
                width: 232,
                height: 234,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 232,
                      height: 234,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://via.placeholder.com/232x234"),
                          fit: BoxFit.fill,
                        ),
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
