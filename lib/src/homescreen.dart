import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'models/book_model.dart';
import 'widgets/Book_category.dart';
import 'widgets/home_top_info.dart';
import 'widgets/search_field.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Book> _books = List();

  Book book;

  DatabaseReference recentJobsref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = Book(
        id: "",
        name: "",
        category: "",
        diskon: 0,
        harga: 0,
        imagePath: "",
        rating: 0);
    FirebaseDatabase database = FirebaseDatabase.instance;
    recentJobsref = database.reference().child("BUKU");
    recentJobsref.onChildAdded.listen(_dataBertambah);
    recentJobsref.onChildChanged.listen(_dataBerubah);
  }

  _dataBertambah(Event event) {
    setState(() {
      _books.add(Book.fromSnapshot(event.snapshot));
    });
  }

  _dataBerubah(Event event) {
    var datalama = _books.singleWhere((entry) {
      return entry.id == event.snapshot.key;
    });
    setState(() {
      _books[_books.indexOf(datalama)] = Book.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          BookCategory(),
          SizedBox(
            height: 20.0,
          ),
          SearchField(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Populer",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "Lihat semua",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: _books.map(_buildBookItems).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookItems(Book book) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Stack(
          children: <Widget>[
            Container(
              height: 200.0,
              width: 340.0,
              child: Image.network(
                book.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Container(
                height: 70.0,
                width: 400.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black, Colors.black12],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
            Positioned(
              left: 10.0,
              bottom: 15.0,
              right: 10.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        book.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            "(" + book.rating.toString() + " Ulasan)",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Harga",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.0,
                        ),
                      ),
                      Text(book.harga.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                            fontSize: 16.0,
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
