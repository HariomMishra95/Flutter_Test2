import 'package:flutter/material.dart';
import 'package:flutter_test2/Article/article.dart';
import 'package:flutter_test2/Article/articleScreen.dart';
import 'package:flutter_test2/Provider/provider.dart';
import 'package:provider/provider.dart';

class NewsArticle extends StatelessWidget {
  final Article article;

  NewsArticle({required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (article.urlToImage != null)
              Image.network(
                article.urlToImage!,
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(

                    article.title,
                    style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),
                  ),

                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    article.source['name'] ?? 'Unknown source',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  IconButton(
                    icon: Icon(
                      article.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: article.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      context.read<NewsProvider>().toggleFavorite(article);
                    },
                  ),
                ],
              ),

            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                article.publishedAt,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
