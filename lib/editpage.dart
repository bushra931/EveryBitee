import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:everybite/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfile extends StatefulWidget {
  final String userId;
  const EditProfile({super.key, required this.userId});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _pregnancyStatusController =
      TextEditingController(); // New Controller

  bool _passwordVisible = false;
  String? _selectedGender;
  String? _selectedDietaryPreference;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.userId).get();
      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        _nameController.text = userData['full_name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _selectedGender = userData['gender'];
        _ageController.text = userData['age'] ?? '';
        _selectedDietaryPreference = userData['dietary_preference'];
        _allergiesController.text = userData['allergies'] ?? '';
        _pregnancyStatusController.text =
            userData['pregnancy_status'] ?? ''; // Fetch pregnancy status
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error loading user data: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Start showing loader
      });

      // Simulate a brief wait to keep the loader visible for a short time
      Future.delayed(const Duration(milliseconds: 300), () async {
        try {
          await _firestore.collection('users').doc(widget.userId).update({
            'full_name': _nameController.text.trim(),
            'gender': _selectedGender,
            'age': _ageController.text.trim(),
            'dietary_preference': _selectedDietaryPreference,
            'allergies': _allergiesController.text.trim(),
            'pregnancy_status': _pregnancyStatusController.text.trim(),
          });

          // Once the update is complete, show a toast and navigate
          Fluttertoast.showToast(
            msg: "Profile updated successfully.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
          );

          // Immediately hide the loader and navigate
          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => Homepage(userId: widget.userId)),
          );
        } catch (e) {
          // Hide loader and show error if update fails
          setState(() {
            _isLoading = false;
          });

          Fluttertoast.showToast(
            msg: "Error updating profile: ${e.toString()}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _allergiesController.dispose();
    _pregnancyStatusController.dispose(); // Dispose the controller
    super.dispose();
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
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.6),
            ),
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
                        "Edit Profile",
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
                            value: _selectedGender,
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
                            value: _selectedDietaryPreference,
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
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 251, 249, 249)),
                            ),
                          ),
                          const SizedBox(height: 17),
                          TextFormField(
                            controller:
                                _pregnancyStatusController, // New field for pregnancy status
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              labelText: 'Pregnancy Status',
                              prefixIcon: Icon(Icons.pregnant_woman),
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
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
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
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 25),
                            ),
                            child: const Text('Update Profile'),
                          ),
                          const SizedBox(height: 15),
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
