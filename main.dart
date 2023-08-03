import "package:flutter/material.dart";
import './ui/HomePage.dart';
import './ui/GifPage.dart';

void main() {
  runApp(
      MaterialApp(
        home: HomePage(),
        theme: ThemeData(
          hintColor: Colors.white,
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            hintStyle:
              TextStyle(color: Colors.white)
          ),
        ),
      )
  );
}