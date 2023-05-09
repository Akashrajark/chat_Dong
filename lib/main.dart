import 'package:chat_app/ui/screen/getstarted.dart';
import 'package:chat_app/ui/screen/home_screen.dart';
import 'package:chat_app/ui/screen/signup_screen.dart';
import 'package:chat_app/value/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: primaryColor,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SignUpScreen(),
    ),
  );
}
