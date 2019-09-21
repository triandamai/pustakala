import 'package:Pustakala/src/models/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailProduk extends StatefulWidget {
  final Book book;
  DetailProduk({this.book});
  @override
  _DetailProdukState createState() => _DetailProdukState();
}

class _DetailProdukState extends State<DetailProduk> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  String uid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          uid = user.uid;
        });
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.book.name}"),
        ),
        body: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipRRect(
                      child: Image.network(
                        "${widget.book.imagePath}",
                        width: MediaQuery.of(context).size.width - 20,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "${widget.book.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                child: Row(
                  children: <Widget>[
                    Text("Kategori : ${widget.book.category}"),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Harga :  Rp ${widget.book.harga}"),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Deksripsi",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Text(
                        '"${widget.book.deskripsi}"',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        if (uid == null || uid == "") {
                          Fluttertoast.showToast(
                              msg: "Kamu belum Login",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          saveMinat();
                        }
                      },
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.thumb_up),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Suka"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.add_shopping_cart),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Keranjang"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  if (uid == null || uid == "") {
                    Fluttertoast.showToast(
                        msg: "Kamu belum login",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    savePesan();
                  }
                },
                child: Container(
                  height: 50.0,
                  margin: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  child: Center(
                    child: Text(
                      "Pesan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveMinat() async {
    FirebaseUser user = await _auth.currentUser();
    FirebaseDatabase.instance
        .reference()
        .child("MINAT")
        .child(user.uid)
        .child("${widget.book.id}")
        .set({
      "id_buku": "${widget.book.id}",
      "jumlah": 1,
      "judul": "${widget.book.name}",
      "image": "${widget.book.imagePath}",
      "harga": "${widget.book.harga}"
    }).then((_) {
      Fluttertoast.showToast(
          msg: "Anda menyukai ${widget.book.name}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.pink,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  void savePesan() async {
    FirebaseUser user = await _auth.currentUser();

    FirebaseDatabase.instance
        .reference()
        .child("PESANAN")
        .child(user.uid)
        .child(widget.book.id)
        .set({
      "id_buku": "${widget.book.id}",
      "jumlah": 1,
      "judul": "${widget.book.name}",
      "image": "${widget.book.imagePath}",
      "harga": "${widget.book.harga}"
    }).then((_) {
      FirebaseDatabase.instance.reference().child("BIAYA").child(user.uid).set({
        "total": widget.book.harga,
        "diskon": widget.book.diskon,
      }).then((_) {
        Fluttertoast.showToast(
            msg: "Menyimpan Ke Daftar Pesanan",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    });
  }
}
