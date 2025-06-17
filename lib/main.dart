import 'package:booker/models/book.dart';
import 'package:booker/screens/book_details_screen.dart';
import 'package:booker/screens/favorites_screen.dart';
import 'package:booker/screens/search_screen.dart';
import 'package:booker/services/favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'services/book_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => BookService()),
        Provider(create: (context) => FavoriteService()),
      ],
      child: MaterialApp(
        title: 'BookFinder',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 1,
          ),
        ),
        home: const HomeScreen(),
        routes: {
          '/details': (context) {
            final book = ModalRoute.of(context)!.settings.arguments as Book;
            return BookDetailScreen(book: book);
          },
          '/favorites': (context) {
            return const FavoritesScreen();
          },
          '/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}
