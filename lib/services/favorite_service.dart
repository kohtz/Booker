import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class FavoriteService {
  static const String _favoritesKey = 'favorite_books';

  // Adicionar livro aos favoritos
  Future<void> addFavorite(Book book) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    // Verifica se já está nos favoritos
    if (!favorites.any((f) => f.id == book.id)) {
      favorites.add(book);
      await _saveFavorites(favorites);
    }
  }

  // Remover livro dos favoritos
  Future<void> removeFavorite(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.removeWhere((book) => book.id == bookId);
    await _saveFavorites(favorites);
  }

  // Obter todos os favoritos
  Future<List<Book>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((item) => Book.fromMap(item)).toList();
    }
    return [];
  }

  // Verificar se um livro é favorito
  Future<bool> isFavorite(String bookId) async {
    final favorites = await getFavorites();
    return favorites.any((book) => book.id == bookId);
  }

  // Salvar lista de favoritos
  Future<void> _saveFavorites(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = books.map((book) => book.toMap()).toList();
    await prefs.setString(_favoritesKey, json.encode(jsonList));
  }
}
