import 'package:Pustakala/src/models/minat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/signin_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Minat> _minats = List();
  List<int> jumla = List();
  Minat book;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;

  DatabaseReference recentJobsref;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = Minat(
      id_buku: "",
      image: "",
      judul: "",
      jumlah: 0,
    );
    getUser().then((user) {
      if (user != null) {
        FirebaseDatabase database = FirebaseDatabase.instance;
        recentJobsref = database.reference().child("MINAT").child(user.uid);
        recentJobsref.onChildAdded.listen(_dataBertambah);
        recentJobsref.onChildChanged.listen(_dataBerubah);
        recentJobsref.onValue.listen(_dataBerubah);
        setState(() {
          _uid = user.uid;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  _dataBertambah(Event event) {
    setState(() {
      _minats.add(Minat.fromSnapshot(event.snapshot));
    });
  }

  _dataBerubah(Event event) {
    var datalama = _minats.singleWhere((entry) {
      return entry.id_buku == event.snapshot.key;
    });
    setState(() {
      _minats[_minats.indexOf(datalama)] = Minat.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_minats.length <= 0) {
      return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/not_found.png",
              width: MediaQuery.of(context).size.width - 80,
            ),
            Center(
              child: Text(
                "Semua buku yang kamu like akan muncul disini ",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Minat Anda",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Flexible(
              child: new ListView.builder(
                itemCount: _minats.length,
                itemBuilder: (BuildContext context, int index) {
                  jumla.add(_minats[index].jumlah);
                  return new Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFD3D3D3), width: 2.0),
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
                                        add(_minats[index].key, index,
                                            _minats[index].jumlah);
                                      },
                                      child: Icon(Icons.keyboard_arrow_up,
                                          color: Color(0xFFD3D3D3))),
                                  Expanded(
                                    child: Text(
                                      "${jumla[index]}",
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.grey),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        min(_minats[index].key, index,
                                            _minats[index].jumlah);
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
                                "${_minats[index].image}",
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
                                "${_minats[index].judul}",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Rp ${_minats[index].harga}",
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
                              remove(_minats[index].key, index);
                              Fluttertoast.showToast(
                                  msg:
                                      "Menghapus pesanan ${_minats[index].judul}",
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
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildTotalContainer(),
      );
    }
  }

  Widget _buildTotalContainer() {
    return Container(
      height: 220.0,
      padding: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (_uid == "" || _uid == null) {
                Fluttertoast.showToast(
                    msg: "Kamu Belum Login..",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => SignInPage()));
              } else {
                Fluttertoast.showToast(
                    msg: "Coming soon",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: Container(
              height: 50.0,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Center(
                child: Text(
                  "Pesan Buku",
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
            height: 20.0,
          ),
        ],
      ),
    );
  }

  void savePesan(String key, index) async {}
  void remove(String key, index) async {
    FirebaseDatabase.instance
        .reference()
        .child("MINAT")
        .child(_uid)
        .child(key)
        .remove();
    setState(() {
      _minats.removeAt(index);
    });
  }

  void add(String key, index, val) async {
    int jumlah = val;
    setState(() {
      jumlah++;
      jumla[index] = jumlah;
    });
    FirebaseDatabase.instance
        .reference()
        .child("MINAT")
        .child(_uid)
        .child(key)
        .update({"jumlah": jumlah});
  }

  void min(String key, index, val) async {
    int jumlah = val;
    if (jumlah <= 1) {
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
        jumlah--;
        jumla[index] = jumlah;
      });
      FirebaseDatabase.instance
          .reference()
          .child("MINAT")
          .child(_uid)
          .child(key)
          .update({"jumlah": jumlah});
    }
  }
}
