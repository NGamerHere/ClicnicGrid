import 'package:flutter/material.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => __SalesScreen();
}

class __SalesScreen extends State<SalesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales")),
      body: Center(child: Text('Home', style: TextStyle(fontSize: 24))),
    );
  }
}
