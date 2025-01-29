import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback navigateToHomePage;
  final VoidCallback navigateToProfilePage;

  const CustomBottomNavBar({
    required this.currentIndex,
    required this.navigateToHomePage,
    required this.navigateToProfilePage,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SizedBox(
            height: 50,
            // Adjust the size of the image
            child: Image.asset('assets/image/1.png'),
          ),
          label: '', // No label for the image
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
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
      case 2: // Navigate to Profile
        navigateToProfilePage();
        break;
      default:
        // No action for index 1 (Image)
        break;
    }
  }
}
