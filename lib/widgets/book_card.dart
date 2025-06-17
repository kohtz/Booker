import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            // Capa do livro
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
              book.thumbnail,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
              ),
            ),

            // Informações do livro
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                Text(
                  book.title,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                  Expanded(
                    child: Text(
                    book.authorsFormatted,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${book.pageCount} págs',
                    style: TextStyle(color: Colors.grey[700], fontSize: 10),
                  ),
                  ],
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}