import 'package:flutter/material.dart';
import 'book.dart';
import 'book_tile.dart';
import 'api_service.dart';
import 'book_detail_screen.dart';

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> books = [];
  List<Book> filteredBooks = [];  // This will hold the filtered list of books
  bool isLoading = false;
  String nextUrl = 'https://gutendex.com/books/';
  ScrollController _scrollController = ScrollController();
  TextEditingController _searchController = TextEditingController();  // Controller for search by title
  TextEditingController _authorSearchController = TextEditingController();  // Controller for search by author

  @override
  void initState() {
    super.initState();
    _fetchBooks(url: nextUrl);
    _scrollController.addListener(_onScroll);

    // Add listeners to update filtered books based on the search query
    _searchController.addListener(() {
      _filterBooks(_searchController.text, _authorSearchController.text);  // Search by title and author
    });
    _authorSearchController.addListener(() {
      _filterBooks(_searchController.text, _authorSearchController.text);  // Search by title and author
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _authorSearchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch books from the API with pagination
  _fetchBooks({required String url}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final data = await ApiService.fetchBooks(url: url);
      setState(() {
        books.addAll(data['results'].map<Book>((item) => Book.fromJson(item)).toList());
        filteredBooks = List.from(books);  // Initially, display all books
        nextUrl = data['next'] ?? '';  // Update next URL
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching books: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load books')),
      );
    }
  }

  // Detect when the user reaches the bottom of the list
  _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _fetchBooks(url: nextUrl);  // Load more books when bottom is reached
    }
  }

  // Filter books by both title and author
  _filterBooks(String titleQuery, String authorQuery) {
    setState(() {
      filteredBooks = books.where((book) {
        final matchesTitle = titleQuery.isEmpty || book.title.toLowerCase().contains(titleQuery.toLowerCase());
        final matchesAuthor = authorQuery.isEmpty || book.authors.any((author) => author.toLowerCase().contains(authorQuery.toLowerCase()));

        return matchesTitle && matchesAuthor;  // Books must match both title and author queries
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BookSearchDelegate(books: books),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),  // Adjusted height to fit both search bars
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // Title Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                SizedBox(height: 8), // Space between search bars

                // Author Search Bar
                TextField(
                  controller: _authorSearchController,
                  decoration: InputDecoration(
                    hintText: 'Search by author...',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchBooks(url: nextUrl);  // Load more books when bottom is reached
          }
          return true;
        },
        child: GridView.builder(
          controller: _scrollController,  // Use the defined ScrollController
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width > 600) ? 3 : 2,  // Responsive layout
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filteredBooks.length,  // Show the filtered list
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailScreen(bookId: book.id),
                  ),
                );
              },
              child: BookTile(book: book),
            );
          },
        ),
      ),
    );
  }
}

class BookSearchDelegate extends SearchDelegate {
  final List<Book> books;

  BookSearchDelegate({required this.books});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // Clear the search input when tapped
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';  // Clear the query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);  // Close the search delegate when the back button is pressed
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase());  // Filter by title
    }).toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width > 600) ? 3 : 2,  // Responsive layout
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailScreen(bookId: book.id),
              ),
            );
          },
          child: BookTile(book: book),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = books.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase());  // Filter by title
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final book = suggestions[index];
        return ListTile(
          title: Text(book.title),
          onTap: () {
            query = book.title;  // Set the query to the selected book title
            showResults(context);  // Show the search results
          },
        );
      },
    );
  }
}
