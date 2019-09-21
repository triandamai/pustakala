import 'package:Pustakala/src/models/minat.dart';
import 'package:Pustakala/src/widgets/favorite_card.dart';
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
                  return FavoriteCard(
                    minat: _minats[index],
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

  void savePesan() async {}
}
