# book_discovery

A Flutter project.

## Project Insights

This project is regarding book discovery app.

The key points are
1. Home screen has list of books displayed with author name and book title. The list will keep on increasing as we scroll down like in gmail app.
2. The detail screen has info in detail for the particular screen
3. Now, there are three 3 types of search bars
   a. Search by title
   b. Search by author
   c. Search by keyword

   
## Design  and flow details
1. The app starts from main.dart , which will in turn open BookListScreen
2. BookListScreen has these things,
   a. fetchbooks from api(http package used) and display it to Grid View with 2 columns
   b. 3 types of search bars, one with search by title, one with search by author, and one with search by keyword.
3. BookDetailScreen which will show the clicked book details by first calling api(using http package) and then displaying all the relevant details regarding clicked book.

## Packages used (additional)
1. http: ^1.2.2
2. cached_network_image: ^3.2.0

## Plugins Used
1. "dev.flutter.flutter-plugin-loader" version "1.0.0"
2. "com.android.application" version "8.3.2"
3. "org.jetbrains.kotlin.android" version "2.0.20"

## In apps build.gradle
1. ndkVersion used "25.1.8937393"
2. Java used => JavaVersion.VERSION_17
3. jvmTarget = 17

## Gradle-Wrapper.properties
Distribution url: https://services.gradle.org/distributions/gradle-8.10.2-all.zip
   
