import 'package:everybite/bottomnav.dart';
import 'package:everybite/editpage.dart';
import 'package:everybite/homepage.dart';
import 'package:everybite/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:everybite/termsAndConditions.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? user;
  String profilePicUrl = "";
  String userName = "Bushra";

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user data from Firestore
  void _getUserData() async {
    user = _auth.currentUser; // Fetch the current logged-in user
    if (user != null) {
      // Using the user's UID to fetch the profile data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc['full_name']; // Set username from Firestore data
          profilePicUrl =
              userDoc['profilePicture'] ?? ""; // Set profile picture URL
        });
      }
    } else {
      // If no user is logged in, navigate to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  // Upload and update profile picture
  Future<void> _updateProfilePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      String fileName =
          "profile_${user!.uid}.jpg"; // Unique profile picture name

      try {
        TaskSnapshot uploadTask =
            await _storage.ref("profile_pictures/$fileName").putFile(file);

        String downloadUrl = await uploadTask.ref.getDownloadURL();
        await _firestore.collection('users').doc(user!.uid).update({
          'profilePicture':
              downloadUrl, // Update profile picture URL in Firestore
        });

        setState(() {
          profilePicUrl = downloadUrl; // Set the updated profile picture URL
        });
      } catch (e) {
        print("Error uploading: $e");
      }
    }
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Homepage(
                userId: user!.uid,
              )),
    );
  }

  void navigateToProfilePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  // Sign out the user
  void _signOut() async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              // Profile Image (Tap to change)
              GestureDetector(
                onTap: _updateProfilePicture,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profilePicUrl.isNotEmpty
                      ? NetworkImage(profilePicUrl)
                      : AssetImage("assets/image/4.png") as ImageProvider,
                ),
              ),
              SizedBox(height: 10),
              // Display User Name
              Text(
                userName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Buttons
              _buildProfileButton("Edit Personal Details", Icons.edit, () {
                // Navigating to EditProfile page when the button is pressed
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditProfile(userId: user!.uid), // Pass userId
                    ));
              }),
              _buildProfileButton("Terms and Policy", Icons.description, () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>TermsAndConditionsPage(), // Pass userId
                    ));
              }),
              _buildProfileButton("Sign Out", Icons.logout, _signOut),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 2, // Profile Tab Index
        navigateToHomePage: () => navigateToHomePage(context),
        navigateToProfilePage: () => navigateToProfilePage(context),
      ),
    );
  }

  // Custom Button Widget (Full Width)
  Widget _buildProfileButton(String text, IconData icon, Function onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 70, // Full width
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () => onTap(),
          icon: Icon(icon, color: Colors.white),
          label: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
