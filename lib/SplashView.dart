import 'package:flutter/material.dart';
import 'SignUp.dart';
import 'TimeLine.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    try {
      // Check if the user is already signed in
      User? user = _auth.currentUser;
      print("user is $user");

      // Delay for a few seconds to show the splash screen
      await Future.delayed(const Duration(seconds: 2));

      if (user != null) {
        // User is signed in, navigate to the home screen
        print('User is signed in. Navigating to TimeLine...');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TimeLine()),
        );
      } else {
        // User is not signed in, navigate to the sign-in screen
        print('User is not signed in. Navigating to SignUp...');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignUp()),
        );
      }
    } catch (e) {
      print('Error checking sign-in status: $e');
      // Handle errors if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can return your splash screen UI here
    return Scaffold(
      body: Center(
        child: Image.asset('assets/REALSplashview-by-freepik.jpg'), // Replace this with your splash screen UI
      ),
    );
  }
}