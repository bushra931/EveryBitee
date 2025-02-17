import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToProfilePage;
  final VoidCallback navigateToScanPage; // Add this callback for scan screen

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.navigateToHomePage,
    required this.navigateToProfilePage,
    required this.navigateToScanPage, // Add this in constructor
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // BottomNavigationBarItem(
        //   icon: SizedBox(
        //     height: 20,
        //     // Adjust the size of the image
        //     child: Image.asset('assets/image/samwich.png'),
        //   ),
        //   label: '', // No label for the image
        // ),
         BottomNavigationBarItem(
          icon: Icon(Icons.fastfood), // Icon for food
          label: 'Scan', // You can change the label to anything suitable
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        // New button to navigate to scan page
       
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.grey[200],
      elevation: 0,
      onTap: (index) {
        _handleNavigation(index);
      },
    );
  }

  void _handleNavigation(int index) {
    switch (index) {
      case 0: // Navigate to Home
        navigateToHomePage();
        break;
      case 1:
       navigateToScanPage(); // Navigate to Profile
        
        break;
      case 2: // Navigate to Scan page (your new screen)
       navigateToProfilePage();
        break;
      default:
        // No action for index 1 (Image)
        break;
    }
  }
}
