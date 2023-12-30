import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class EnvironmentalLawyersPage extends StatefulWidget {
  const EnvironmentalLawyersPage({super.key});

  @override
  _EnvironmentalLawyersPageState createState() =>
      _EnvironmentalLawyersPageState();
}

class _EnvironmentalLawyersPageState extends State<EnvironmentalLawyersPage> {
  late List<Lawyer> lawyers;

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  Future<void> fetchLawyers() async {
    final lawyersCollection =
    FirebaseFirestore.instance.collection('environmental_lawyers');

    final lawyersData = await lawyersCollection.get();

    setState(() {
      lawyers = lawyersData.docs
          .map((doc) => Lawyer.fromFirestore(doc))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environmental Lawyers'),
      ),
      // ignore: unnecessary_null_comparison
      body: lawyers == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: lawyers.length,
        itemBuilder: (context, index) {
          final lawyer = lawyers[index];
          return LawyerCard(lawyer: lawyer);
        },
      ),
    );
  }
}

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerCard({super.key, required this.lawyer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(lawyer.imageUrl),
            ),
          ),
        ),
        title: Text(lawyer.name),
        subtitle: Text(lawyer.email),
        trailing: ElevatedButton(
          onPressed: () {
           _launchEmail();
          },
          child: const Text('Contact'),
        ),
      ),
    );
  }
}

class Lawyer {
  final String name;
  final String email;
  final String imageUrl;

  Lawyer({
    required this.name,
    required this.email,
    required this.imageUrl,
  });

  factory Lawyer.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lawyer(
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? 'No Email',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
_launchEmail() async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: '{lawyer.email}',
    queryParameters: {'subject': 'Subject of the email', 'body': 'Body of the email'},
  );

  if (await canLaunchUrl(emailLaunchUri)) {
    await launchUrl(emailLaunchUri);
  } else {
    // Handle error
    throw 'Could not launch $emailLaunchUri';
  }
}