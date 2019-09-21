import 'package:Pustakala/src/models/book_model.dart';
import 'package:flutter/material.dart';

class BookPopuler extends StatefulWidget {
  final Book book;
  BookPopuler({this.book});

  @override
  _BookPopulerState createState() => _BookPopulerState();
}

class _BookPopulerState extends State<BookPopuler> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            width: 340.0,
            child: Image.network(
              widget.book.imagePath,
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
                      widget.book.name,
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
                          "(" + widget.book.rating.toString() + " Ulasan)",
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
                    Text(widget.book.harga.toString(),
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
    );
  }
}
