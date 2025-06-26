import 'package:flutter/material.dart';

class Maintitle extends StatelessWidget {
  const Maintitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/main_title.png',
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}