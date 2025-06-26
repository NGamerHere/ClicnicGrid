import 'package:flutter/material.dart';

import './dashboardScreens/Dashboard.dart';
import './dashboardScreens/pharmacy.dart';
import "./dashboardScreens/Settings.dart";
import "./dashboardScreens/PatientsPage.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Pages to show when you tap different icons
  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const PharmacyPage(),
    const PatientsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_information_outlined),
            label: 'Pharmacy',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "management"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        // which one is active
        selectedItemColor: const Color(0xFF8435A5),
        onTap: _onItemTapped, // when tapped, call this
      ),
    );
  }
}
