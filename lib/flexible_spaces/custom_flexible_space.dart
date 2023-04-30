import 'package:flutter/material.dart';

const String lightBackgroundPath = 'images/day.png';
const String nightBackgroundPath = 'images/night.png';

class CustomFlexibleSpace extends Container {
  CustomFlexibleSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(lightBackgroundPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
