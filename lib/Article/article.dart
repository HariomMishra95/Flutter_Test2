import 'package:flutter/material.dart';
import 'package:flutter_test2/Article/newsArticle.dart';
import 'package:flutter_test2/Provider/provider.dart';
import 'package:provider/provider.dart';

class Article {
  final String title;
  final String? urlToImage;
  final String publishedAt;
  final Map<String, dynamic> source;
  final String content;
  final String url;
  bool isFavorite;

  Article({
    required this.title,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
    required this.content,
    required this.url,
    this.isFavorite = false,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? '',
      source: json['source'] ?? {},
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'source': source,
      'content': content,
      'url': url,
      'isFavorite': isFavorite,
    };
  }
}




class ArticleSearchDelegate extends SearchDelegate<Article> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    context.read<NewsProvider>().fetchNews(searchQuery: query);
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        if (newsProvider.news.isEmpty) {
          return Center(
            child: Text('No results found'),
          );
        } else {
          return ListView.builder(
            itemCount: newsProvider.news.length,
            itemBuilder: (context, index) {
              return NewsArticle(article: newsProvider.news[index]);
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text('Search for news...'),
    );
  }
}
