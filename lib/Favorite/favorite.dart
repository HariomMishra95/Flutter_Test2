import 'package:flutter/material.dart';
import 'package:flutter_test2/Article/newsArticle.dart';
import 'package:flutter_test2/Provider/provider.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.redAccent,
        title: Text('Favorites',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.favorites.isEmpty) {
            return Center(
              child: Text('No favorite articles.'),
            );
          } else {
            return ListView.builder(
              itemCount: newsProvider.favorites.length,
              itemBuilder: (context, index) {
                return NewsArticle(article: newsProvider.favorites[index]);
              },
            );
          }
        },
      ),
    );
  }
}
