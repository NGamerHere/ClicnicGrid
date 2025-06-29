import 'package:flutter/material.dart';

import './dashboardScreens/Dashboard.dart';
import './dashboardScreens/pharmacy.dart';
import "./dashboardScreens/Settings.dart";
import "./dashboardScreens/PatientsScreen.dart";
import '../theme/colourSchema.dart';
import "../components/ScreenUtils.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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

  bool isWide(BuildContext context) => MediaQuery.of(context).size.width > 800;


  @override
  Widget build(BuildContext context) {
    final isWideScreen = isWide(context);

    return Scaffold(
      body: Row(
        children: [
          if (isWideScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: AppColors.mainColour),
              selectedLabelTextStyle: TextStyle(color: AppColors.mainColour),
              destinations: const [
                NavigationRailDestination(
                    icon: Icon(Icons.home), label: Text('Home')),
                NavigationRailDestination(
                    icon: Icon(Icons.medical_information_outlined),
                    label: Text('Pharmacy')),
                NavigationRailDestination(
                    icon: Icon(Icons.people), label: Text('Management')),
                NavigationRailDestination(
                    icon: Icon(Icons.settings), label: Text('Settings')),
              ],
            ),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: isWideScreen
          ? null
          : BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.mainColour,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.medical_information_outlined),
              label: 'Pharmacy'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: "Management"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}