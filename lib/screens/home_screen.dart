import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> _featuredBooks;
  late Future<List<Book>> _recentBooks;

  @override
  void initState() {
    super.initState();
    _featuredBooks =
        Provider.of<BookService>(context, listen: false).fetchPopularBooks();
    _recentBooks =
        Provider.of<BookService>(context, listen: false).fetchRecentBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookFinder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/search'),
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de busca

              const SizedBox(height: 24),

              // Seção de livros em destaque
              const Text(
                'Livros em Destaque',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: FutureBuilder<List<Book>>(
                  future: _featuredBooks,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Erro: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Book book = snapshot.data![index];
                          return SizedBox(
                            width: 180,
                            child: BookCard(
                              book: book,
                              onTap: () => _navigateToDetails(context, book),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('Nenhum livro encontrado'),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Seção de novos lançamentos
              const Text(
                'Novos Lançamentos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<Book>>(
                future: _recentBooks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Book book = snapshot.data![index];
                        return BookCard(
                          book: book,
                          onTap: () => _navigateToDetails(context, book),
                        );
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Book book) {
    Navigator.pushNamed(context, '/details', arguments: book);
  }
}
