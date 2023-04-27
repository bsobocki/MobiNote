import 'package:flutter/material.dart';

class MountainsFlexibleSpace extends Container {
  MountainsFlexibleSpace({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/cartoon-mountain.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
