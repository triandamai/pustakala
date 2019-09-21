import 'package:Pustakala/src/models/minat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/signin_page.dart';
import '../widgets/order_card.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Minat> _pesanans = List();
  Minat book;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid;
  int total;
  int diskon;
  int ppn = 10;
  double subtotal;
  DatabaseReference recentJobsref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user != null) {
        book = Minat(id_buku: "", image: "", judul: "", jumlah: 0);
        FirebaseDatabase database = FirebaseDatabase.instance;
        recentJobsref = database.reference().child("PESANAN").child(user.uid);
        recentJobsref.onChildAdded.listen(_dataBertambah);
        recentJobsref.onChildChanged.listen(_dataBerubah);
        recentJobsref.onValue.listen(_dataBerubah);
        recentJobsref.onChildRemoved.listen(_dtaDihapus);
        setState(() {
          _uid = user.uid;
        });
      }
      getHarga().then((DataSnapshot snap) {
        setState(() {
          total = snap.value["total"];
          diskon = snap.value["diskon"];
          subtotal = (total * diskon) / 100 - ppn;
        });
      });
    });
  }

  Future<DataSnapshot> getHarga() async {
    return FirebaseDatabase.instance
        .reference()
        .child("BIAYA")
        .child(_uid)
        .once();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  _dataBertambah(Event event) {
    setState(() {
      _pesanans.add(Minat.fromSnapshot(event.snapshot));
    });
  }

  _dtaDihapus(Event event) {
    setState(() {
      _pesanans.remove(event.snapshot);
    });
  }

  _dataBerubah(Event event) {
    var datalama = _pesanans.singleWhere((entry) {
      return entry.id_buku == event.snapshot.key;
    });
    setState(() {
      _pesanans[_pesanans.indexOf(datalama)] =
          Minat.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_pesanans.length <= 0) {
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
                "Kamu Belum Pesan Buku ",
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
            "Belanjaan Anda",
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
                itemCount: _pesanans.length,
                itemBuilder: (BuildContext context, int index) {
                  return OrderCard(
                    minat: _pesanans[index],
                    uid: _uid,
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
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Subtotal",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp $total",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Diskon",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "$diskon %",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "PPN",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp $ppn",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(
            height: 2.0,
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Total",
                style: TextStyle(
                    color: Color(0xFF9BA7C6),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Rp $subtotal",
                style: TextStyle(
                    color: Color(0xFF6C6D6D),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
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
                  "Proses Pembayaran",
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
}
