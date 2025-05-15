import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

import 'package:checkpoint/page_select.dart';

const String strapiUrl = 'http://localhost:1337';

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ArticleScreen(),
    );
  }
}

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key});

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  List articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    final response =
        await http.get(Uri.parse('$strapiUrl/api/articles?populate=*'));
    if (response.statusCode == 200) {
      print('Raw API Response: ${jsonEncode(response.body)}');
      setState(() {
        articles = jsonDecode(response.body)['data'];
      });
    }
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Strapi + Flutter')),
        body: ListView.builder(
          //itemCount: articles.length,
          itemBuilder: (context, index) {
            var article = articles[index];
            debugPrint(article.toString());
            return Row(
              children: [
                Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // if (article['image] != null)
                          Image.network('$strapiUrl${article['cover']['url']}'),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  article['title'],
                                  style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(article['description']),
                                  //Text('${article['blocks'][0]['body']}'),
                              ],
                            ),
                            
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
}