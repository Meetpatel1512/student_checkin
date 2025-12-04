import 'package:flutter/material.dart';
import 'package:student_checkin/screens/add_student.dart';
import 'package:student_checkin/screens/check_in.dart';
import 'package:student_checkin/screens/home_screen.dart';
import 'package:iconsax/iconsax.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const AddStudent(),
    const HomeScreen(),
    const CheckInScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),

          child: NavigationBar(
            selectedIndex: _currentIndex,
            indicatorColor: Colors.blueGrey,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Iconsax.user_add),
                label: 'Add Student',
              ),
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(
                icon: Icon(Iconsax.timer_1),
                label: 'Check In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
