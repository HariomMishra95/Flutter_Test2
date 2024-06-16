import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test2/Article/article.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class NewsProvider with ChangeNotifier {
  List<Article> _news = [];
  List<Article> _favorites = [];
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool hasMoreData = true;
  String _selectedCategory = 'general'; // Default category
  String _errorMessage = '';

  List<Article> get news => _news;
  List<Article> get favorites => _favorites;
  bool get isFetchingMore => _isFetchingMore;
  String get errorMessage => _errorMessage;

  NewsProvider() {
    _loadFavorites();
  }

  Future<void> fetchNews({bool isLoadMore = false, String? searchQuery}) async {
    if (isLoadMore && !hasMoreData) {
      return;
    }

    if (!isLoadMore) {
      _currentPage = 1;
      _news.clear();
    }

    final baseUrl = 'https://newsapi.org/v2/top-headlines?country=us';
    final categoryPart = '&category=$_selectedCategory';
    final searchPart = searchQuery != null && searchQuery.isNotEmpty ? '&q=$searchQuery' : '';
    final pagePart = '&page=$_currentPage';
    final apiKey = '&apiKey=3d48ac7ea50346d282ffceb3778551b5';
    final url = Uri.parse('$baseUrl$categoryPart$searchPart$pagePart$apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> articlesJson = jsonData['articles'];
        if (articlesJson.isEmpty) {
          hasMoreData = false;
        } else {
          _news.addAll(
              articlesJson.map((article) => Article.fromJson(article)).toList());
          _currentPage++;
        }
        if (isLoadMore) {
          _isFetchingMore = false;
        }
        _errorMessage = '';
        notifyListeners();
      } else {
        throw Exception('Failed to load news: ${response.reasonPhrase}');
      }
    } catch (e) {
      _errorMessage = "Error fetching news: $e";
      if (isLoadMore) {
        _isFetchingMore = false;
      }
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchNews();
  }

  void toggleFavorite(Article article) {
    article.isFavorite = !article.isFavorite;
    if (article.isFavorite) {
      _favorites.add(article);
    } else {
      _favorites.removeWhere((a) => a.url == article.url);
    }
    _saveFavorites();
    notifyListeners();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteArticles = prefs.getStringList('favorites') ?? [];
    _favorites = favoriteArticles
        .map((article) => Article.fromJson(jsonDecode(article)))
        .toList();
    notifyListeners();
  }

  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteArticles = _favorites.map((article) => jsonEncode(article.toJson())).toList();
    prefs.setStringList('favorites', favoriteArticles);
  }
}
