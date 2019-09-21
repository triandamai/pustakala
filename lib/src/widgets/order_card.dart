import 'package:Pustakala/src/models/minat.dart';
import 'package:Pustakala/src/pages/order_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderCard extends StatefulWidget {
  final Minat minat;
  final String uid;
  OrderCard({this.minat, this.uid});
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  int _jumlah;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          _uid = user.uid;
          _jumlah = widget.minat.jumlah;
        });
        print("${_uid}");
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD3D3D3), width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              width: 45.0,
              height: 73.0,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          add();
                        },
                        child: Icon(Icons.keyboard_arrow_up,
                            color: Color(0xFFD3D3D3))),
                    Expanded(
                      child: Text(
                        "$_jumlah",
                        style: TextStyle(fontSize: 18.0, color: Colors.grey),
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          min();
                        },
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFFD3D3D3))),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Container(
              height: 70.0,
              width: 70.0,
              child: ClipRRect(
                child: Image.network(
                  "${widget.minat.image}",
                ),
                borderRadius: new BorderRadius.circular(40),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5.0,
                        offset: Offset(0.0, 2.0))
                  ]),
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "${widget.minat.judul}",
                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "Rp ${widget.minat.harga}",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Container(
                  height: 25.0,
                  width: 120.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text("Biografi",
                              style: TextStyle(
                                  color: Color(0xFFD3D3D3),
                                  fontWeight: FontWeight.w400)),
                          SizedBox(
                            width: 5.0,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                remove();
                Fluttertoast.showToast(
                    msg: "Menghapus pesanan ${widget.minat.judul}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void remove() async {
    databaseReference
        .child("PESANAN")
        .child(_uid)
        .child(widget.minat.key)
        .remove();
    OrderPage orderPage;
    orderPage.createState();
  }

  void add() async {
    setState(() {
      _jumlah++;
    });
    databaseReference
        .child("PESANAN")
        .child(_uid)
        .child(widget.minat.key)
        .update({"jumlah": _jumlah});
  }

  void min() async {
    if (_jumlah <= 0) {
      Fluttertoast.showToast(
          msg: "Menghapus ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        _jumlah--;
      });
      databaseReference
          .child("PESANAN")
          .child(_uid)
          .child(widget.minat.key)
          .update({"jumlah": _jumlah});
    }
  }
}
