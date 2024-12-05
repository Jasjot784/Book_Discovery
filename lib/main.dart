import 'package:flutter/material.dart';
import 'book_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
//
// // Model for the Book
// class Book {
//   final String title;
//   final String imageUrl;
//
//   Book({required this.title, required this.imageUrl});
//
//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       title: json['title'],
//       imageUrl: json['formats']['image/jpeg'] ?? '',
//     );
//   }
// }
//
// class BookListScreen extends StatefulWidget {
//   @override
//   _BookListScreenState createState() => _BookListScreenState();
// }
//
// class _BookListScreenState extends State<BookListScreen> {
//   List<Book> books = [];
//   bool isLoading = false;
//   String? nextUrl;
//
//   // Function to fetch books from the API
//   Future<void> fetchBooks({String? url}) async {
//     if (isLoading) return; // Prevent multiple requests while loading
//
//     setState(() {
//       isLoading = true;
//     });
//
//     final response = await http.get(Uri.parse(url ?? 'https://gutendex.com/books/'));
//
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       final List<Book> newBooks = (data['results'] as List).map((bookJson) => Book.fromJson(bookJson)).toList();
//
//       setState(() {
//         books.addAll(newBooks);
//         nextUrl = data['next']; // Get next URL for pagination
//         isLoading = false;
//       });
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       // Handle error, you can show a message or a retry button
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchBooks(); // Initial fetch
//   }
//
//   // Function to load more books when the user reaches the bottom
//   // Function to load more books when the user reaches the bottom
//   bool _loadMoreBooks(ScrollNotification notification) {
//     if (notification is ScrollUpdateNotification &&
//         notification.metrics.pixels == notification.metrics.maxScrollExtent) {
//       if (nextUrl != null && !isLoading) {
//         fetchBooks(url: nextUrl); // Load next set of books
//       }
//       return true; // Return true to indicate the notification has been handled
//     }
//     return false; // Return false to propagate the notification further
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book List'),
//       ),
//       body: NotificationListener<ScrollNotification>(
//         onNotification: _loadMoreBooks,
//         child: GridView.builder(
//           padding: EdgeInsets.all(10),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,  // Two columns
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 10,
//             childAspectRatio: 0.75, // Adjust the aspect ratio of each grid item
//           ),
//           itemCount: books.length + (isLoading ? 1 : 0), // Add loading indicator at the end
//           itemBuilder: (context, index) {
//             if (index == books.length && isLoading) {
//               return Center(child: CircularProgressIndicator());
//             }
//
//             final book = books[index];
//             return Card(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: CachedNetworkImage(
//                       imageUrl: book.imageUrl,
//                       placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//                       errorWidget: (context, url, error) => Icon(Icons.error),
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       book.title,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: BookListScreen(),
//   ));
// }
