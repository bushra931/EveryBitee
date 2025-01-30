import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everybite/homepage.dart';
import 'package:everybite/signuppage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = ''; // Variable to hold error message

  Future<void> _loginWithEmail() async {
    setState(() {
      _errorMessage = ''; // Clear any previous error messages
    });

    try {
      // Attempt to sign in with the email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if the user is logged in successfully
      User? user = userCredential.user;

      String userid = _auth.currentUser!.uid;

      if (user != null) {
        // If login is successful, navigate to the home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Homepage(userId: userid)), // Replace with your desired page
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Login failed. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handling specific Firebase authentication errors
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: 'No user found for that email. Please check the email address.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(
          msg: 'Incorrect password. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'invalid-email') {
        Fluttertoast.showToast(
          msg: 'The email address is not valid. Please check the format.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (e.code == 'too-many-requests') {
        Fluttertoast.showToast(
          msg: 'Too many login attempts. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
      print(
          "Firebase Auth Error: ${e.code}"); // Optional: for debugging purposes
    } catch (e) {
      // Handling other types of errors (e.g., network connectivity)

      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      print("General Error: $e"); // Optional: for debugging purposes
    }
  }

  Future<void> _forgotPassword() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password reset email sent!")),
        );
      } catch (e) {
        setState(() {
          _errorMessage = 'Error sending password reset email.';
        });
        print("Error resetting password: $e");
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter your email.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToSignup() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image/1.png', // Replace with your image path
              fit: BoxFit.cover, // Makes the image cover the entire background
            ),
          ),
          // Semi-transparent Overlay (optional, for readability)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4), // Dark overlay
            ),
          ),
          // Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Login Heading
                  Text(
                    'Login',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40), // Space below heading
                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20), // Space between fields
                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      controller: _passwordController,
                      obscureText: !passwordVisible,
                    ),
                  ),

                  TextButton(
                    onPressed: _forgotPassword,
                    child: const Text(
                      "Forgot Password?",
                      style:
                          TextStyle(color: Color.fromARGB(255, 254, 254, 254)),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ), // Space before login button
                  // Login Button
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loginWithEmail,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      backgroundColor: Color(0xFFA7FF4F), // Custom button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: navigateToSignup,
                      child: const Text(
                        "Create a new account",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
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
