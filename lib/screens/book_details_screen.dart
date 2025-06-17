import 'package:booker/screens/book_reader_screen.dart';
import 'package:booker/services/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final favoriteService = Provider.of<FavoriteService>(context, listen: false);
    bool isFavorite = false;

    return FutureBuilder<bool>(
      future: favoriteService.isFavorite(book.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          isFavorite = snapshot.data!;
          return _buildScaffold(context, isFavorite, favoriteService);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Scaffold _buildScaffold(
    BuildContext context,
    bool isFavorite,
    FavoriteService favoriteService,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'book-cover-${book.id}',
                child: CachedNetworkImage(
                  imageUrl: book.thumbnail,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.book, size: 100, color: Colors.grey),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
                onPressed: () async {
                  if (isFavorite) {
                    await favoriteService.removeFavorite(book.id);
                  } else {
                    await favoriteService.addFavorite(book);
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite
                            ? 'Removido dos favoritos'
                            : 'Adicionado aos favoritos',
                      ),
                    ),
                  );

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BookDetailScreen(book: book),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Por ${book.authorsFormatted}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (book.averageRating != null) ...[
                        _buildRatingStars(book.averageRating!),
                        const SizedBox(width: 8),
                        Text(
                          '${book.averageRating!.toStringAsFixed(1)} (${book.ratingsCount ?? 0} avaliações)',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                      const Spacer(),
                      Icon(Icons.menu_book, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${book.pageCount} páginas'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildInfoBadge(
                        icon: Icons.calendar_today,
                        text: 'Publicado: ${book.publishedYear}',
                      ),
                      _buildInfoBadge(
                        icon: Icons.store,
                        text: 'Editora: ${book.publisher}',
                      ),
                      if (book.categories.isNotEmpty)
                        _buildInfoBadge(
                          icon: Icons.category,
                          text: 'Categoria: ${book.categories.join(", ")}',
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    book.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text('LER AMOSTRA GRÁTIS'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => _openBookPreview(context),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(double rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 20,
        );
      }),
    );
  }

  Widget _buildInfoBadge({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[700]),
        ),
      ],
    );
  }

  void _openBookPreview(BuildContext context) {
    if (book.previewLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Prévia não disponível para este livro')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookReaderScreen(
          previewUrl: book.previewLink,
          bookTitle: book.title,
        ),
      ),
    );
  }
}
