// lib/screens/book_detail_screen.dart

import 'package:flutter/material.dart';
import 'api_service.dart';
import 'book.dart';

class BookDetailScreen extends StatefulWidget {
  final int bookId;

  BookDetailScreen({required this.bookId});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Future<Book> book;

  @override
  void initState() {
    super.initState();
    // Call the API to fetch the book details using the book ID
    book = _fetchBookDetail(widget.bookId);
  }

  Future<Book> _fetchBookDetail(int bookId) async {
    final response = await ApiService.fetchBooks(
        url: 'https://gutendex.com/books/$bookId/');
    return Book.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details"),
      ),
      body: FutureBuilder<Book>(
        future: book,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            final bookDetail = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(bookDetail.coverImageUrl),
                    SizedBox(height: 16),
                    Text(
                      bookDetail.title,
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'by ${bookDetail.authors.join(', ')}',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Subjects: ${bookDetail.subjects.join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Languages: ${bookDetail.languages.join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Download Count: ${bookDetail.downloadCount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Bookshelves: ${bookDetail.bookshelves.join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Media Type: ${bookDetail.mediaType}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
