import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goe/AppInfo.dart';
import 'package:goe/SignUp.dart';
import 'package:goe/SuggestSol.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Methods.dart';
import 'TimeLine.dart';
import 'Account.dart';
import 'package:firebase_storage/firebase_storage.dart';
class ReportAbuse extends StatefulWidget {
  const ReportAbuse({super.key});

  @override

  // ignore: library_private_types_in_public_api
  _ReportAbusePageState createState() => _ReportAbusePageState();
}

class _ReportAbusePageState extends State<ReportAbuse> {
  final TextEditingController briefDescriptionController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  List<File> selectedImages = [];

  @override
  void initState() {
    super.initState();
    _checkUserAuthentication();
  }

  Future<void> _checkUserAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, show error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please sign in to access this screen.'),
      ));

      // Navigate to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()), // Replace with your sign-in screen
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  Future<void> _sendReport() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, show error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please sign in to send a report.'),
      ));

      // Navigate to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()), // Replace with your sign-in screen
      );
      return;
    }

    if (briefDescriptionController.text.isEmpty ||
        longDescriptionController.text.isEmpty ||
        addressController.text.isEmpty) {
      // Show an error message or handle validation as needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fill in the report.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Assuming you have set up Firebase and initialized Firestore
    final CollectionReference reportsCollection = FirebaseFirestore.instance.collection('abuse_reports');

    // Save the report data to Firestore with user's UID
    // Save the report data to Firestore with user's UID
    DocumentReference reportReference = await reportsCollection.add({
      'userId': user.uid,
      'briefDescription': briefDescriptionController.text,
      'longDescription': longDescriptionController.text,
      'address': addressController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Upload images to Firebase Storage
    for (int i = 0; i < selectedImages.length; i++) {
      File imageFile = selectedImages[i];

      // Generate a unique name for the image
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      // Reference to the Firebase Storage bucket
      Reference storageReference = FirebaseStorage.instance.ref().child('report_images/$imageName.jpg');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update the Firestore document with the image URL
      await reportReference.update({
        'images': FieldValue.arrayUnion([imageUrl]),
      });
    }

    // Clear form fields and selected images after sending the report
    setState(() {
      briefDescriptionController.clear();
      longDescriptionController.clear();
      addressController.clear();
      selectedImages.clear();
    });

    // Optionally show a success message or navigate to another page
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your report was sent successfully.'),
          duration: Duration(seconds: 2),
        ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TimeLine()),
    );
  }


  @override
  Widget build(BuildContext context) {

    // Bottom Navigation bar added here !
    BottomNavBar(
      currentIndex: 2, // Set the index for the current page
      onTap: (index) {
        // Handle navigation based on the selected index
        switch (index) {
          case 0:
          // Navigate to the Home page (current page)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TimeLine()),
            );
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
          /*     Navigator.pushReplacement(
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
    );

    return Scaffold(

      appBar: AppBar(
        title: const Text('Report Abuse Against Environment:'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: briefDescriptionController,
              maxLength: 60,
              decoration: const InputDecoration(labelText: 'Brief Description (max 60 characters)'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: longDescriptionController,
              maxLength: 350,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Long Description (max 350 characters)'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                for (int i = 0; i < selectedImages.length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      selectedImages[i],
                      height: 50.0,
                      width: 50.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (selectedImages.length < 5)
                  ElevatedButton(
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    child: const Icon(Icons.add),
                  ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendReport,
              child: const Text('Send Report'),
            ),
          ],
        ),
      ),
    );
  }
}
