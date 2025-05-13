import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
//import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:convert';

import 'package:checkpoint/page_select.dart';

const String strapiUrl = 'http://localhost:1337';

double imageWidth = 200.0;
double imageHeight = 100.0;

double gridCrossAxisSpacing = 10.0;

double coverImagePadding = gridCrossAxisSpacing * 0.8;

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
            ),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            var article = articles[index];
            //debugPrint(article.toString());
            return Card(
              shadowColor: Colors.cyan[200],
              elevation: 4.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              child: Stack(
                //fit: StackFit.expand,
                children: [
                  // if (article['image] != null)
                  Image.network(
                    '$strapiUrl${article['cover']['url']}',
                    height: 200,
                    //fit: BoxFit.contain,
                    fit: BoxFit.cover, //crop image but will fill card which looks good
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.black38,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article['title'],
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                ),
                              ),
                            //card description, might delete because it must be short in order to be readable.
                            Text( 
                              overflow: TextOverflow.ellipsis,
                              article['description'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => PageSelect()),
                          );
                        },
                        //splashColor: Colors.amber,
                      ),
                    )
                    )
                ],
              ),
            );
          },
        ),
      );
    }
}