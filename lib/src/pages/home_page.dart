import 'package:Pustakala/src/pages/detail_produk.dart';
import 'package:Pustakala/src/pages/popular.dart';
import 'package:Pustakala/src/widgets/book_category.dart';
import 'package:Pustakala/src/widgets/home_top_info.dart';
import 'package:Pustakala/src/widgets/search_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/book_model.dart';
import '../widgets/book_populer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> _books = List();
  Book book;

  Query recentJobsref;
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
    recentJobsref = database
        .reference()
        .child("BUKU")
        .orderByChild("rating")
        .limitToLast(5);
    recentJobsref.onChildAdded.listen(_dataBertambah);
    recentJobsref.onChildChanged.listen(_dataBerubah);
    recentJobsref.onValue.listen(_dataBerubah);
  }

  @override
  void dispose() {
    super.dispose();
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
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            headerSliverBuilder: (BuildContext ctx, bool inner) {
              return <Widget>[
                SliverAppBar(
                    backgroundColor: Colors.white,
                    expandedHeight: 250,
                    floating: false,
                    pinned: true,
                    flexibleSpace: Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50.0,
                          ),
                          HomeTopInfo(),
                          BookCategory(),
                        ],
                      ),
                    ),
                    bottom: PreferredSize(
                      child: SearchField(),
                      preferredSize: null,
                    )),
              ];
            },
            body: Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Populer",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PopularPage()));
                        },
                        child: Text(
                          "Lihat semua",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Flexible(
                    child: new ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        print(_books.length);
                        return _buildBookItems(_books[index]);
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _buildBookItems(Book book) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailProduk(book: book)));
        },
        child: BookPopuler(
          book: book,
        ),
      ),
    );
  }
}
