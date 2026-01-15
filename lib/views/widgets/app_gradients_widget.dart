// app_gradients.dart
import 'package:flutter/material.dart';

class AppGradients {
  static const chat = LinearGradient(
    colors: [
      Color.fromARGB(128, 255, 230, 200),
      Color.fromARGB(201, 82, 161, 239),
      Color.fromARGB(255, 64, 108, 251),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

