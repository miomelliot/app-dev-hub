import 'package:flutter/material.dart'; 
 
void main() { 
  runApp(BookApp()); 
} 
 
class BookApp extends StatelessWidget { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      debugShowCheckedModeBanner: false, 
      title: 'Каталог книг', 
      theme: ThemeData( 
        primarySwatch: Colors.blue, 
      ), 
      home: BooksScreen(), 
    ); 
  } 
} 
enum Genre{Fiction, NonFiction} 
 
class Book{ 
  final int id; 
  final String title; 
  final String author; 
  final int year; 
  final String imageUrl; 
  final String description; 
  final Genre genre; 
  bool isFavorite; 
 
  Book({ 
    required this.id, 
    required this.title, 
    required this.author, 
    required this.year, 
    required this.imageUrl, 
    required this.description, 
    required this.genre, 
    this.isFavorite = false, 
  }); 
} 
 
class BooksScreen extends StatefulWidget { 
  @override 
  State<BooksScreen> createState() => _BooksScreenState(); 
} 
enum BookFilter{All, Fiction, NonFiction} 
 
class _BooksScreenState extends State<BooksScreen> { 
  List<Book> allBooks = [ 
    Book( 
      id: 1, 
      title: '1984', 
      author: 'запрещен', 
      year: 2015, 
      imageUrl: "https:/example.com/tip.png", 
      description: 'черно-блое издание', 
      genre: Genre.NonFiction, 
    ), 
    Book( 
      id: 2, 
      title: 'Рассказ служанки', 
      author: 'запрещен', 
      year: 2017, 
      imageUrl: "https:/example.com/bpd.png", 
      description: 'цветное издание', 
      genre: Genre.NonFiction, 
    ), 
    Book( 
      id: 3, 
      title: 'Сборник сказок', 
      author: 'разрешен', 
      year: 1998, 
      imageUrl: "https:/example.com/sim.png", 
      description: 'Издание с иллюстрациями', 
      genre: Genre.Fiction, 
    ), 
  ]; 
 
  Genre selectedGenre = Genre.Fiction; 
  List<Book> filteredBooks = []; 
  List<Book> favoriteBooks = []; 
  bool _isAscending = true; 
  BookFilter selectedFilter = BookFilter.All; 
  @override 
  void initState(){ 
    super.initState(); 
    filteredBooks = allBooks; 
  } 
  void _filterBooks(){ 
    setState(() { 
      if(selectedFilter == BookFilter.All){ 
        filteredBooks = allBooks; 
      }else if(selectedFilter == BookFilter.Fiction){ 
        filteredBooks = allBooks.where((book)=>book.genre==Genre.Fiction).toList(); 
      }else { 
        filteredBooks = allBooks.where((book)=>book.genre==Genre.NonFiction).toList(); 
      } 
    }); 
  } 
  void _sortBooks(){ 
    setState(() { 
          filteredBooks.sort((a, b)=> 
          _isAscending?a.title.compareTo(b.title):b.title.compareTo(a.title)); 
        }); 
  } 
  void _addBook(String title, String author, int year, String imageUrl, String description, Genre genre){ 
    setState(() { 
             allBooks.add( 
              Book( 
                id: allBooks.length+1, 
                title: title, 
                author: author, 
                year: year, 
                imageUrl: imageUrl, 
                description: description, 
                genre: genre, 
              ), 
             ); 
             _filterBooks(); 
        }); 
   } 
   Future<void> _showAddBookDialog(BuildContext context) async{ 
    final titleController = TextEditingController(); 
    final authorController = TextEditingController(); 
    final yearController = TextEditingController(); 
    final imageUrlController = TextEditingController(); 
    final descriptionController = TextEditingController(); 
    final genreController = TextEditingController(); 
 
    return showDialog<void>( 
      context: context, 
      builder: (BuildContext context){ 
        return AlertDialog( 
          title: Text('Добавить книгу'), 
          content: StatefulBuilder( 
            builder: (BuildContext context, StateSetter setState){ 
              return SingleChildScrollView( 
            child: Column( 
              children: <Widget>[ 
                TextField( 
                  controller: titleController, 
                  decoration: InputDecoration(labelText: 'Название'),
                ), 
                TextField( 
                  controller: authorController, 
                  decoration: InputDecoration(labelText: 'Автор'), 
                ), 
                TextField( 
                  controller: yearController, 
                  decoration: InputDecoration(labelText: 'Год издания'), 
                ), 
                TextField( 
                  controller: imageUrlController, 
                  decoration: InputDecoration(labelText: 'Изображение'), 
                ), 
                TextField( 
                  controller: descriptionController, 
                  decoration: InputDecoration(labelText: 'Описание'), 
                ), 
                DropdownButton<Genre>( 
                  value: selectedGenre, 
                  onChanged: (Genre?newValue){ 
                    setState(() { 
                             if(newValue!=null){ 
                             selectedGenre = newValue; 
                             } 
                        }); 
                  }, 
                  items: Genre.values.map((Genre genre){ 
                    return DropdownMenuItem<Genre>( 
                      value: genre, 
                      child: Text(genre==Genre.Fiction?"детские сказки":"научка"), 
                      ); 
                    }).toList(), 
                ), 
              ], 
            ), 
          ); 
          },), 
          actions: <Widget>[ 
            TextButton( 
              child: Text('Отмена'), 
              onPressed: (){ 
                Navigator.of(context).pop(); 
              }, 
            ), 
            TextButton( 
              child: Text('Добавить'), 
              onPressed: (){ 
                final title = titleController.text; 
                final author = authorController.text; 
                final year = int.tryParse(yearController.text)??0; 
                final imageUrl = imageUrlController.text; 
                final description = descriptionController.text; 
                if(title.isNotEmpty && author.isNotEmpty && year>0 && imageUrl.isNotEmpty && description.isNotEmpty){ 
                  _addBook(title, author, year, imageUrl, description, selectedGenre); 
                  Navigator.of(context).pop(); 
                } 
              }, 
            ), 
          ], 
        ); 
      }); 
   } 
 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text('Каталог книг'), 
        actions: [ 
          IconButton( 
            icon: Icon(_isAscending? Icons.arrow_upward:Icons.arrow_downward), 
            onPressed: (){ 
              setState(() { 
                              _isAscending = !_isAscending; 
                              _sortBooks(); 
                            }); 
            }, 
          ), 
          IconButton( 
            icon: Icon(Icons.favorite), 
            onPressed: ()async{ 
              final Book?removedBook = await Navigator.push( 
                context, 
                MaterialPageRoute( 
                  builder: (context)=>FavoriteBooksScreen(favoriteBooks:favoriteBooks), 
 
                ), 
              ); 
              if(removedBook != null){ 
                setState(() { 
                        removedBook.isFavorite = false; 
                        favoriteBooks.remove(removedBook); 
                }); 
              } 
            }, 
          ) 
        ],), 
      body: Column( 
        children: [ 
          Row( 
            children: [ 
              Expanded( 
                child: RadioListTile<BookFilter>( 
                  title: Text('Все'), 
                  value: BookFilter.All, 
                  groupValue: selectedFilter, 
                  onChanged: (BookFilter?value){ 
                    setState(() { 
                            selectedFilter = value!; 
                            _filterBooks(); 
                    }); 
                  }, 
                ), 
              ), 
               Expanded( 
                child:
RadioListTile<BookFilter>( 
                  title: Text('детские сказки'), 
                  value: BookFilter.Fiction, 
                  groupValue: selectedFilter, 
                  onChanged: (BookFilter?value){ 
                    setState(() { 
                            selectedFilter = value!; 
                            _filterBooks(); 
                    }); 
                  }, 
                ), 
              ), 
               Expanded( 
                child: RadioListTile<BookFilter>( 
                  title: Text('научка'), 
                  value: BookFilter.NonFiction, 
                  groupValue: selectedFilter, 
                  onChanged: (BookFilter?value){ 
                    setState(() { 
                            selectedFilter = value!; 
                            _filterBooks(); 
                    }); 
                  }, 
                ), 
              ), 
              ],), 
               Expanded( 
                child: ListView.builder( 
                  itemCount: filteredBooks.length, 
                  itemBuilder: (context, index){ 
                    final book = filteredBooks[index]; 
                    return ListTile( 
                      title: Text(book.title), 
                      subtitle: Text(book.author), 
                      trailing: IconButton( 
                        icon: Icon( 
                          book.isFavorite? Icons.star: Icons.star_border, 
                        ), 
                        onPressed: (){ 
                          setState(() { 
                                book.isFavorite = !book.isFavorite; 
                                if (book.isFavorite){ 
                                  favoriteBooks.add(book); 
                                }else { 
                                  favoriteBooks.remove(book); 
                                } 
                          }); 
                        }, 
                      ), 
                    ); 
                  }, 
                ) 
              ), 
            ],), 
            floatingActionButton: FloatingActionButton( 
              onPressed:() => _showAddBookDialog(context), 
              child: Icon(Icons.add), 
            ), 
    ); 
  } 
} 
 
class FavoriteBooksScreen extends StatelessWidget { 
  final List<Book> favoriteBooks; 
 
  FavoriteBooksScreen({required this.favoriteBooks}); 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        title: Text("Избранное"), 
      ), 
      body: favoriteBooks.isEmpty?Center( 
        child: Text("Нетизбранных книг")): 
        ListView.builder( 
          itemCount: favoriteBooks.length, 
          itemBuilder: (context, index){ 
            final book = favoriteBooks[index]; 
            return ListTile( 
              title: Text(book.title), 
              subtitle: Text(book.author), 
              trailing: IconButton( 
                icon: Icon(Icons.delete), 
                onPressed: (){ 
                  Navigator.pop(context, book); 
                }, 
              ), 
            ); 
          }, 
        ), 
      ); 
  } 
}