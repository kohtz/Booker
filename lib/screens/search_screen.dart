// screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:debounce_throttle/debounce_throttle.dart'; // Não é mais necessário
import '../models/book.dart';
import '../services/book_service.dart';
import '../widgets/book_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Book> _searchResults = [];
  bool _isSearching = false;
  bool _freeOnly = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // O listener no _searchController não é mais necessário para acionar a busca
    // Ele será útil apenas para limpar os resultados se o campo for esvaziado manualmente
    // Mas para "buscar apenas ao confirmar", removemos a lógica de busca daqui.
    // _searchController.addListener(_onSearchChanged); // Remover esta linha
  }

  @override
  void dispose() {
    // _searchController.removeListener(_onSearchChanged); // Remover esta linha
    _searchController.dispose();
    super.dispose();
  }

  // Novo método para executar a busca apenas ao confirmar
  void _executeSearch(String query) async {
    // Se a query estiver vazia, limpa os resultados e reseta o estado
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _errorMessage = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = ''; // Limpa mensagens de erro anteriores
    });

    try {
      final bookService = Provider.of<BookService>(context, listen: false);
      final results = await bookService.searchBooks(
        query,
        freeOnly: _freeOnly,
        language: 'pt', // Você pode considerar 'pt-BR' para ser mais específico
      );
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Falha na busca: ${e.toString()}';
        _isSearching = false;
      });
    }
  }

  // Método para lidar com a mudança do filtro "apenas gratuitos"
  // Ele vai re-executar a busca com o termo atual
  void _onFreeOnlyChanged(bool value) {
    setState(() {
      _freeOnly = value;
    });
    // Re-executa a busca com o termo atual quando o filtro muda
    _executeSearch(_searchController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buscar Livros')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Campo de busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Digite título, autor ou assunto...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    // Ao limpar, também limpa os resultados
                    _executeSearch(''); // Chamar com query vazia para limpar
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              autofocus: true,
              // ***** MUDANÇA PRINCIPAL AQUI *****
              onSubmitted: (query) {
                _executeSearch(query.trim());
              },
              // **********************************
            ),
            const SizedBox(height: 16),

            // Filtros
            Row(
              children: [
                const Text('Apenas gratuitos:'),
                Switch(
                  value: _freeOnly,
                  onChanged: _onFreeOnlyChanged, // Usar o novo método
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Resultados
            Expanded(child: _buildResultsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList() {
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage));
    }

    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    // Se o campo de busca estiver vazio e não houver resultados, mostra a mensagem inicial
    if (_searchController.text.isEmpty && _searchResults.isEmpty) {
      return const Center(child: Text('Digite algo para buscar livros'));
    }

    if (_searchResults.isEmpty) {
      return const Center(child: Text('Nenhum livro encontrado'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final book = _searchResults[index];
        return BookCard(book: book, onTap: () => _navigateToDetails(book));
      },
    );
  }

  void _navigateToDetails(Book book) {
    Navigator.pushNamed(context, '/details', arguments: book);
  }
}
