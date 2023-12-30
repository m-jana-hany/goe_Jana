import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goe/LogIn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign up:',
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _usernameController = TextEditingController();
  String _selectedGovernorate = 'Governorate'; // Initialize with a default value
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _signUpWithEmailAndPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text,
        );

        // Add user data to Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'username': _usernameController.text.trim(),
          'governorate': _selectedGovernorate,
        });

        print('User signed up with email and password: ${userCredential.user}');
      } catch (e) {
        print('Error signing up: $e');
      }
    }
  }

  void _signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      print('User signed in with Google: ${userCredential.user}');
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  //design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(backgroundColor: const Color(0xff5C9A2E),
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Sign Up', style: TextStyle(fontSize: 27,
            color: Color(0xFFFCE4D4),fontWeight: FontWeight.bold),),),

      body: SingleChildScrollView(
         scrollDirection: Axis.vertical,

          child:
          Padding( padding: const EdgeInsets.all(10.0), child:
 
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [

                  const SizedBox(height: 30,),

                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username', 
                                    filled: true,
                                    fillColor: Color(0xffdddea6),
                                    suffixIcon: Icon(Icons.account_circle_outlined, ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 10) {
                        return 'Username must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
            
            
                  DropdownButtonFormField<String>(
                    value: _selectedGovernorate,
                    onChanged: (value) {
                      setState(() {
                        _selectedGovernorate = value!;
                      });
                    },
                    items: [
                      'Governorate',
                      'Cairo',
                      'Alexandria',
                      'Giza',
                      'Monoufia',
                      'Port Said',
                      'Suez',
                      'Luxor',
                      'Dakahlia',
                      'Gharbia',
                      'Matrouh',
                      'Asyut',
                      'Ismailia',
                      'Fayoum',
                      'Al-Sharqia',
                      'Aswan',
                      'Damietta',
                      'Beheira',
                      'El-Minya',
                      'Beni Suef',
                      'Hurghada',
                      'Qena',
                      'Sohag',
                      'New Valley',
                      'North Sinai',
                      'Kafr El Sheikh',
                      'South Sinai',
                    ].map((governorate) {
                      return DropdownMenuItem(
                        value: governorate,
                        child: Text(governorate),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Governorate'),
                    validator: (value) {
                      if (value == null || value == 'Governorate') {
                        return 'Governorate is required';
                      }
                      return null;
                    },
                  ),
            
            
            
                  const SizedBox(height: 16.0),
            
                  TextFormField(
                                   controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'ID number as a password',  filled: true,
                                    fillColor: Color(0xffdddea6),
                                    suffixIcon: Icon(Icons.perm_identity),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black)
                                ),),                          
                   keyboardType: TextInputType.number,

                    validator: (value) {
                      if (value == null || value.length != 14) {
                        return 'ID must be exactly 14 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: _signUpWithEmailAndPassword,
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('or'),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google),
                          onPressed: _signInWithGoogle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () {
                    // Navigate to the sign-in page
                  Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LogIn()),
             ); 
                    },
                    child: const Text('Already have an account? Sign In' ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
