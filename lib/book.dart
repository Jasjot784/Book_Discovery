// lib/models/book.dart

class Book {
  final int id;
  final String title;
  final String coverImageUrl;
  final List<String> authors;
  final List<String> subjects;
  final List<String> bookshelves;
  final List<String> languages;
  final int downloadCount;
  final String mediaType;

  Book({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.authors,
    required this.subjects,
    required this.bookshelves,
    required this.languages,
    required this.downloadCount,
    required this.mediaType,
  });

  // Factory constructor to create a Book instance from a JSON object
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['formats']['image/jpeg'] ?? '',
      authors: (json['authors'] as List)
          .map((author) => author['name'] as String)
          .toList(),
      subjects: (json['subjects'] as List)
          .map((subject) => subject as String)
          .toList(),
      bookshelves: (json['bookshelves'] as List)
          .map((shelf) => shelf as String)
          .toList(),
      languages: (json['languages'] as List)
          .map((language) => language as String)
          .toList(),
      downloadCount: json['download_count'] ?? 0,
      mediaType: json['media_type'] ?? 'Text',
    );
  }
}
