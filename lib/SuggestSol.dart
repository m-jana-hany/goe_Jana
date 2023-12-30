import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goe/ReportAbuse.dart';
import 'package:goe/SignUp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AppInfo.dart';
import 'Methods.dart';
import 'TimeLine.dart';
import 'Account.dart';

class SuggestSol extends StatefulWidget {
  const SuggestSol({super.key});

  @override
  _SuggestSol createState() => _SuggestSol();
}

class _SuggestSol extends State<SuggestSol> {
  final TextEditingController problemController = TextEditingController();
  final TextEditingController suggestionTitleController = TextEditingController();
  final TextEditingController suggestionController = TextEditingController();


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

  Future<void> _sendSuggestion() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User is not signed in, show error message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please sign in to send a suggestion.'),
      ));

      // Navigate to the sign-in screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUp()), // Replace with your sign-in screen
      );
      return;
    }

    if (problemController.text.isEmpty ||
        suggestionTitleController.text.isEmpty ||
        suggestionController.text.isEmpty) {
print('fill needed data.');
  return;
    }

    // Assuming you have set up Firebase and initialized Firestore
    final CollectionReference reportsCollection = FirebaseFirestore.instance.collection('users_suggestions');

    // Save the report data to Firestore with user's UID
    await reportsCollection.add({
      'userId': user.uid,
      'problem': problemController.text,
      'suggestionTitle': suggestionTitleController.text,
      'suggestion': suggestionController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear form fields and selected images after sending the report
    setState(() {
      problemController.clear();
      suggestionTitleController.clear();
      suggestionController.clear();
    });

    // Optionally show a success message or navigate to another page
    // ...
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Your suggestion was sent successfully.'),
    ));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggest a solution to an environmental problem:'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: problemController,
              decoration: const InputDecoration(labelText: 'The environmental problem'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: suggestionTitleController,
              decoration: const InputDecoration(labelText: 'Title of your suggestion'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: suggestionController,
              decoration: const InputDecoration(labelText: 'Your suggestion'),
            ),
            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _sendSuggestion,
              child: const Text('Send Suggestion'),
            ),
          ],
        ),
      ),
      // Bottom Navigation bar added here !
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Set the index for the current page
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
      ),
    );

  }
}

