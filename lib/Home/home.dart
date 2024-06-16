import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_test2/Article/article.dart';
import 'package:flutter_test2/Article/newsArticle.dart';
import 'package:flutter_test2/Favorite/favorite.dart';
import 'package:flutter_test2/Provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      context.read<NewsProvider>().fetchNews();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50) {
      if (!context.read<NewsProvider>().isFetchingMore &&
          context.read<NewsProvider>().hasMoreData) {
        context.read<NewsProvider>().fetchNews(isLoadMore: true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: Colors.redAccent,
        title: Text('News App',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ArticleSearchDelegate());
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
          PopupMenuButton(
            onSelected: (String category) {
              context.read<NewsProvider>().setCategory(category);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem(
                value: 'business',
                child: Text('Business'),
              ),
              PopupMenuItem(
                value: 'entertainment',
                child: Text('Entertainment'),
              ),
              PopupMenuItem(
                value: 'general',
                child: Text('General'),
              ),
              PopupMenuItem(
                value: 'health',
                child: Text('Health'),
              ),
              PopupMenuItem(
                value: 'science',
                child: Text('Science'),
              ),
              PopupMenuItem(
                value: 'sports',
                child: Text('Sports'),
              ),
              PopupMenuItem(
                value: 'technology',
                child: Text('Technology'),
              ),
            ],
          ),

        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.errorMessage.isNotEmpty) {
            return Center(child: Text(newsProvider.errorMessage));
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount:
            newsProvider.news.length + (newsProvider.isFetchingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < newsProvider.news.length) {
                return NewsArticle(article: newsProvider.news[index]);
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

