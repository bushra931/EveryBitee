import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everybite/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedGender;
  String? _selectedDietaryPreference;
  String? _pregnancyStatus;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmail() async {
    // Validation logic...

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        Fluttertoast.showToast(
          msg: "Verification email sent. Please check your inbox.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );

        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Verify Your Email"),
            content: Text(
                "A verification link has been sent to ${user.email}. Please verify your email to complete the sign-up process."),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("OK"),
              ),
            ],
          ),
        );

        _checkEmailVerificationStatus(); // Start polling for verification
      }
    } catch (e) {
      print("Error signing up: $e");
      Fluttertoast.showToast(
        msg: "Sign up failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _checkEmailVerificationStatus() async {
    User? user = _auth.currentUser;

    if (user != null) {
      bool emailVerified = false;

      while (!emailVerified) {
        await Future.delayed(const Duration(seconds: 3)); // Wait 3 seconds
        await user?.reload(); // Refresh user information
        user = _auth.currentUser; // Get updated user instance
        emailVerified = user!.emailVerified;

        if (emailVerified) {
          Fluttertoast.showToast(
            msg: "Email verified successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          // Add user details to Firestore
          await _firestore.collection('users').doc(user.uid).set({
            'full_name': _nameController.text.trim(),
            'email': user.email,
            'profilepic': '',
            'gender': _selectedGender,
            'pregnancy_status': _pregnancyStatus,
            'age': _ageController.text.trim(),
            'dietary_preference': _selectedDietaryPreference,
            'allergies': _allergiesController.text.trim(),
          });

          // Navigate to Userprofile
        
=======
          
        }
      }
    }
  }

  // Future<void> _signUpWithEmail() async {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     setState(() => _isLoading = true);
  //     try {
  //       UserCredential userCredential =
  //           await _auth.createUserWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim(),
  //       );

  //       User? user = userCredential.user;
  //       if (user != null) {
  //         await user.sendEmailVerification();
  //         Fluttertoast.showToast(
  //           msg: "Verification email sent. Please check your inbox.",
  //           toastLength: Toast.LENGTH_LONG,
  //           gravity: ToastGravity.BOTTOM,
  //         );

  //         await _firestore.collection('users').doc(user.uid).set({
  //           'full_name': _nameController.text.trim(),
  //           'email': user.email,
  //           'profilepic': '',
  //           'gender': _selectedGender,
  //           'pregnancy_status': _pregnancyStatus,
  //           'age': _ageController.text.trim(),
  //           'dietary_preference': _selectedDietaryPreference,
  //           'allergies': _allergiesController.text.trim(),
  //         });

  //         showDialog(
  //           context: context,
  //           builder: (context) => AlertDialog(
  //             title: const Text("Verify Your Email"),
  //             content: Text(
  //                 "A verification link has been sent to ${user.email}. Please verify your email to complete the sign-up process."),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.of(context).pop(),
  //                 child: const Text("OK"),
  //               ),
  //             ],
  //           ),
  //         );
  //         setState(() {
  //           _isLoading = false;
  //         });

  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(
  //             builder: (context) => Homepage(userId: user.uid),
  //           ),
  //         );
  //       }
  //     } catch (e) {
  //       Fluttertoast.showToast(
  //         msg: "Sign up failed: ${e.toString()}",
  //         toastLength: Toast.LENGTH_LONG,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //       );
  //     } finally {
  //       setState(() => _isLoading = false);
  //     }
  //   }
  // }

  void _askPregnancyStatus() {
    if (_selectedGender == 'Female') {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pregnancy Status"),
          content: const Text("Are you pregnant?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _pregnancyStatus = 'No';
                });
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pregnancyStatus = 'Yes';
                });
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image/1.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6)),
          ),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Create a new account",
                        style: GoogleFonts.ebGaramond(
                          color: const Color.fromARGB(255, 182, 225, 192),
                          fontSize: 25,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 360,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          DropdownButtonFormField<String>(
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: Colors.black,
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                              prefixIcon: Icon(Icons.people_alt_sharp),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Male',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'Female',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'Other',
                                child: Text('Other'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value;
                              });
                              _askPregnancyStatus(); // Check pregnancy status if female
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your gender';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              prefixIcon: Icon(Icons.cake),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  int.tryParse(value) == null) {
                                return 'Please enter a valid age';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          DropdownButtonFormField<String>(
                            style: const TextStyle(color: Colors.white),
                            dropdownColor: Colors.black,
                            decoration: const InputDecoration(
                              labelText: 'Dietary Preference',
                              prefixIcon: Icon(Icons.local_hospital),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Vegetarian',
                                child: Text('Vegetarian'),
                              ),
                              DropdownMenuItem(
                                value: 'Non-Vegetarian',
                                child: Text('Non-Vegetarian'),
                              ),
                              DropdownMenuItem(
                                value: 'Vegan',
                                child: Text('Vegan'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedDietaryPreference = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your dietary preference';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller: _allergiesController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Allergies (if any)',
                              prefixIcon: Icon(Icons.health_and_safety),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!RegExp(
                                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: !_confirmPasswordVisible,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(_confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(18),
                                  right: Radius.circular(18),
                                ),
                              ),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _signUpWithEmail,
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
