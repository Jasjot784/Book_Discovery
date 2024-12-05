// lib/widgets/book_tile.dart

import 'package:flutter/material.dart';
import 'book.dart';

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({required this.book});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        children: [
          // Reduce the image size here
          Image.network(
            book.coverImageUrl,
            fit: BoxFit.cover,  // This will make sure the image covers the available space
            width: double.infinity,
            height: 100, // Reduce the image height
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.error, size: 50); // Fallback if image is not available
            },
          ),
          SizedBox(height: 4), // Space between image and text
          Text(
            book.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4), // Space between title and authors
          Text(
            'by ${book.authors.join(', ')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
