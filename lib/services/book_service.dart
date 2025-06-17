import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String _baseUrl = "https://www.googleapis.com/books/v1/volumes";
  // static const String _apiKey ="SUA_CHAVE_API"; // Obtenha em: https://developers.google.com/books
  final List<String> _popularThemes = [
    "ficcao",
    "romance",
    "historia",
    "autoajuda",
    "culinaria",
    "negocios",
    "biografia",
    "fantasia",
    "ciencia",
    "poesia",
  ];

  // Instância de Random para seleção aleatória
  final Random _random = Random();

  // Busca livros mais populares (orderBy=relevance)
  Future<List<Book>> fetchPopularBooks() async {
    // Seleciona um tema aleatório da lista
    final String randomTheme =
        _popularThemes[_random.nextInt(_popularThemes.length)];
    final response = await http.get(
      Uri.parse(
        "$_baseUrl?q=$randomTheme&orderBy=relevance&maxResults=10&langRestrict=pt-BR",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load popular books');
    }
  }

  // Busca livros mais recentes (orderBy=newest) com tema aleatório
  Future<List<Book>> fetchRecentBooks() async {
    // Seleciona um tema aleatório da lista
    final String randomTheme =
        _popularThemes[_random.nextInt(_popularThemes.length)];
    final response = await http.get(
      Uri.parse(
        "$_baseUrl?q=$randomTheme&orderBy=newest&maxResults=10&langRestrict=pt-BR",
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load recent books');
    }
  }

  Future<List<Book>> searchBooks(
    String query, {
    bool freeOnly = false,
    String language = 'pt',
  }) async {
    final encodedQuery = Uri.encodeComponent(query);
    String url = "$_baseUrl?q=$encodedQuery&maxResults=20";
    
    // Filtros adicionais
    if (freeOnly) url += "&filter=free-ebooks";
    if (language.isNotEmpty) url += "&langRestrict=$language";
    
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> items = data['items'] ?? [];
      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Falha na busca: ${response.statusCode}');
    }
  }


}
