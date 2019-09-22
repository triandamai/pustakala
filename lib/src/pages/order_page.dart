import 'package:Pustakala/src/models/minat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/signin_page.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Minat> _pesanans = List();
  List<int> jumla = List();

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
                  jumla.add(_pesanans[index].jumlah);

                  return Card(
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
                                        add(_pesanans[index].key, index,
                                            _pesanans[index].jumlah);
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
                                        min(_pesanans[index].key, index,
                                            _pesanans[index].jumlah);
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
                                "${_pesanans[index].image}",
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
                                "${_pesanans[index].judul}",
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Rp ${_pesanans[index].harga}",
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
                              remove(_pesanans[index].key, index);
                              Fluttertoast.showToast(
                                  msg:
                                      "Menghapus pesanan ${_pesanans[index].judul}",
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

  void remove(String key, index) async {
    FirebaseDatabase.instance
        .reference()
        .child("PESANAN")
        .child(_uid)
        .child(key)
        .remove()
        .then((_) {
      setState(() {
        _pesanans.removeAt(index);
      });
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
        .child("PESANAN")
        .child(_uid)
        .child(key)
        .update({"jumlah": jumlah});
  }

  void min(String key, index, val) async {
    int jumlah = val;
    if (val <= 1) {
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
          .child("PESANAN")
          .child(_uid)
          .child(key)
          .update({"jumlah": jumlah});
    }
  }
}
