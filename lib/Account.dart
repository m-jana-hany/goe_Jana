import 'dart:io';
import 'package:flutter/material.dart';
import 'package:goe/SignUp.dart';
import 'package:goe/TimeLine.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Methods.dart';
import 'ReportAbuse.dart';
import 'SuggestSol.dart';
import 'AppInfo.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  late User _user;
  late String _username;
  late String _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userData =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        _user = user;
        _username = userData['username'] ?? 'No Username';
        _profileImageUrl = userData['profileImageUrl'] ?? '';
        _isLoading = false;
      });
    } else {
      // User is not signed in, show error message
      setState(() {
        _isLoading = false;
      });

      // Show a message and navigate to the sign-in screen
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please sign in to access this screen.'),
      ));

      // Optional: Navigate to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()),
      );
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to a different screen after sign out if needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TimeLine()),
    );
  }

  Future<void> _setProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(imageFile);

      // Update Firestore document with the image URL
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).update({
        'profileImageUrl': imageUrl,
      });

      // Update the state to reflect the changes
      setState(() {
        _profileImageUrl = imageUrl;
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile image set successfully.'),
      ));
    } else {
      // If the user didn't pick an image, do nothing
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    // Generate a unique name for the image
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    // Reference to the Firebase Storage bucket
    Reference storageReference = FirebaseStorage.instance.ref().child('profile_images/$imageName.jpg');

    // Upload the image to Firebase Storage
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Get the download URL of the uploaded image
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: _profileImageUrl.isEmpty
                  ? const AssetImage('assets/default_profile_image.jpg')
                  : NetworkImage(_profileImageUrl) as ImageProvider,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Name: $_username",
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _setProfileImage,
              child: const Text('Set Profile Image'),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signOut,
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
      // Bottom Navigation bar added here !
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1, // Set the index for the current page
        onTap: (index) {
          // Handle navigation based on the selected index
          switch (index) {
            case 0:
            // Navigate to the Home page (current page)
              break;
            case 1:
            // Navigate to the Account page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Account()),
              );
              break;

            case 2:
            // Navigate to the Report form page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportAbuse()),
              );
              break;

            case 3:
            // Navigate to the Contact Lawyer page
            /*   Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ContactLaw()),
              );
*/
              break;

            case 4:
            // Navigate to the Suggest Solution page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SuggestSol()),
              );
              break;

            case 5:
            // Navigate to the Info About App page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AppInfo()),
              );
              break;
          }
        },
      ),
    );
  }
}