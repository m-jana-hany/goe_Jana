import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Account.dart';
import 'ReportAbuse.dart';
import 'SuggestSol.dart';
import 'Methods.dart';
import 'AppInfo.dart';

class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String sourceName;
  final String author;
  final Uri url;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.sourceName,
    required this.author,
    required this.url,
  });
}

class TimeLine extends StatefulWidget {
  const TimeLine({super.key});

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimeLine> {
  late List<Article> articles;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true;
    });

    const apiKey = "0515919ba5844ba89e2409d8b68492ae";
    const apiUrl = "https://newsapi.org/v2/top-headlines?country=eg&q=الاحتباس الحراري&q=المناخ&q=مناخ&q=البيئة&q=بيئة&from=2023-9-28&sortBy=publishedAt&apiKey=$apiKey";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['articles'];

      setState(() {
        articles = data
            .map((json) => Article(
          title: json['title'],
          description: json['description'],
          urlToImage: json['urlToImage'] ?? '',
          sourceName: json['source']['name'],
          author: json['author'] ?? '',
          url: json['url'],
        ))
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Handle error
      print('Failed to fetch articles: ${response.statusCode}');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Environmental News Feed'),
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchArticles,
        child: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return GestureDetector(
              onTap: () {
                launchURL(article.url);
              },
              child: Card(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.urlToImage.isNotEmpty)
                      Image.network(
                        article.urlToImage,
                        height: 150.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        article.title,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (article.author.isNotEmpty || article.sourceName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'By ${article.author.isNotEmpty ? article.author : article.sourceName}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Share.share('${article.title}\n${article.url}');
                            },
                            child: const Icon(Icons.share),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // Bottom Navigation bar added here !
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set the index for the current page
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

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TimeLine(),
  ));
}

void launchURL(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    print('Could not launch $url');
  }
}