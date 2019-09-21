import 'package:Pustakala/src/models/book_model.dart';
import 'package:Pustakala/src/widgets/book_populer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'detail_produk.dart';

class SearchPage extends StatefulWidget {
  String query;
  SearchPage({this.query});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
      rating: 0,
    );
    FirebaseDatabase database = FirebaseDatabase.instance;
    recentJobsref = database
        .reference()
        .child("BUKU")
        .orderByChild("name")
        .startAt(widget.query)
        .endAt(widget.query + "\uf8ff");

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
    if (_books.length <= 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pencarian"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Menampilkan hasil Pencarian "${widget.query}"',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset(
              "assets/images/not_found.png",
              width: MediaQuery.of(context).size.width - 80,
            ),
            Center(
              child: Text(
                "Tidak ditemukan hasil pencarian ${widget.query} ",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Pencarian"),
          ),
          body: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'Menampilkan hasil Pencarian "${widget.query}"',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: FirebaseAnimatedList(
                    query: recentJobsref,
                    itemBuilder: (_, DataSnapshot snapshot,
                        Animation<double> anim, int index) {
                      return _buildBookItems(_books[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
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
