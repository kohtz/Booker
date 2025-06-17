import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/favorite_service.dart';
import '../widgets/book_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Book>> _favoriteBooks;
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    _favoriteBooks = _favoriteService.getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildBooksGrid(snapshot.data!);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildBooksGrid(List<Book> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Stack(
          children: [
            BookCard(
              book: book,
              onTap: () => _navigateToDetails(context, book),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red),
                onPressed: () => _removeFavorite(book.id),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Nenhum livro favoritado ainda',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Explorar livros'),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Book book) {
    Navigator.pushNamed(context, '/details', arguments: book);
  }

  void _removeFavorite(String bookId) async {
    await _favoriteService.removeFavorite(bookId);
    setState(() {
      _loadFavorites(); 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Livro removido dos favoritos'),
        duration: Duration(seconds: 2),
      ),
    );
  }

}
