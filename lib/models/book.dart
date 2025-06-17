class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String publisher;
  final String publishedDate;
  final String description;
  final int pageCount;
  final String thumbnail;
  final String previewLink;
  final String infoLink;
  final double? averageRating;
  final int? ratingsCount;
  final List<String> categories;
  final bool isFavorite;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publisher,
    required this.publishedDate,
    required this.description,
    required this.pageCount,
    required this.thumbnail,
    required this.previewLink,
    required this.infoLink,
    this.averageRating,
    this.ratingsCount,
    required this.categories,
    this.isFavorite = false
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Título desconhecido',
      authors: List<String>.from(
        volumeInfo['authors'] ?? ['Autor desconhecido'],
      ),
      publisher: volumeInfo['publisher'] ?? 'Editora desconhecida',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      description: volumeInfo['description'] ?? 'Descrição não disponível.',
      pageCount: volumeInfo['pageCount'] ?? 0,
      thumbnail: imageLinks['thumbnail'] ?? '',
      previewLink: volumeInfo['previewLink'] ?? '',
      infoLink: volumeInfo['infoLink'] ?? '',
      averageRating: volumeInfo['averageRating']?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'],
      categories: List<String>.from(volumeInfo['categories'] ?? []),
      isFavorite: false, // Inicialmente não é favorito
    );
  }

  String get authorsFormatted {
    return authors.join(', ');
  }

  String get publishedYear {
    return publishedDate.length >= 4 ? publishedDate.substring(0, 4) : '';
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'publisher': publisher,
      'publishedDate': publishedDate,
      'description': description,
      'pageCount': pageCount,
      'thumbnail': thumbnail,
      'previewLink': previewLink,
      'infoLink': infoLink,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Título desconhecido',
      authors: List<String>.from(map['authors'] ?? ['Autor desconhecido']),
      publisher: map['publisher'] ?? 'Editora desconhecida',
      publishedDate: map['publishedDate'] ?? '',
      description: map['description'] ?? 'Descrição não disponível.',
      pageCount: map['pageCount'] ?? 0,
      thumbnail: map['thumbnail'] ?? '',
      previewLink: map['previewLink'] ?? '',
      infoLink: map['infoLink'] ?? '',
      categories: map['categories'] != null
          ? List<String>.from(map['categories'])
          : [],
      isFavorite: true, 
    );
  }
}
