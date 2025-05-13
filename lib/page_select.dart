import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
import 'dart:convert';

const String strapiUrl = 'http://localhost:1337';

class PageSelect extends StatelessWidget {
  const PageSelect({super.key});

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
      //print('Raw API Response: ${jsonEncode(response.body)}');
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
          itemCount: articles.length,
          itemBuilder: (context, index) {
            var article = articles[index];
            //debugPrint(article.toString());
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 4),
                child: Column(
                  children: [
                    Text(
                      article['title'],
                      //'${article['blocks'][0]['body']}',
                      //"test text row",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 400,
                      width: 350,
                      child: Html(
                        data: '${article['content']}'
                        ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
}