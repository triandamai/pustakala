import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/signin_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool Login_Screen = true;
  String email;
  String uid;
  bool _progressBarActive = true;
  bool isAdmin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          Login_Screen = false;
          email = user.email;
          _progressBarActive = false;
          uid = user.uid;
        });

        getRole().then((DataSnapshot snap) {
          print("${snap.value["role"]}");
          if (snap.value["role"]) {
            setState(() {
              isAdmin = true;
            });
          } else {
            setState(() {
              isAdmin = false;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Login_Screen
          ? new Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                    ),
                    Center(
                      child: Text(
                        "Kamu Belum Login Klik Tombol dibawah untuk masuk",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => SignInPage()));
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(35.0),
                        ),
                        child: Center(
                          child: Text(
                            "Daftar Akun",
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
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: <Widget>[
                SafeArea(
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          SizedBox(
                            height: 90,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {},
                              child: new ClipRRect(
                                child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/flutterislamiccenter.appspot.com/o/Images%2F1568974260925.jpeg?alt=media&token=55da604f-b35f-4e86-b006-3a4ef196f3ea",
                                  height: 80.0,
                                  width: 80.0,
                                ),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Trian ",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                          ),
                          Text(
                            "$email",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                          ),
                          FlatButton(
                            onPressed: () {},
                            child: Text("Ubah Foto Profil"),
                          ),
                          isAdmin
                              ? InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/add');
                                  },
                                  child: Container(
                                      height: 50.0,
                                      margin: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Tambah Produk",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                )
                              : Center(),
                          InkWell(
                            onTap: () {
                              setState(() {
                                this._progressBarActive = true;
                              });
                              LogOut().then((_) {
                                Fluttertoast.showToast(
                                    msg: "Kamu Log Out",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.red[500],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                setState(() {
                                  this.Login_Screen = true;
                                  this._progressBarActive = false;
                                });
                              });
                              // Navigator.pushNamed(context, '/add');
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
                                  "Log Out",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _progressBarActive
                    ? SafeArea(
                        child: Scaffold(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          body: Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1.0, 2.0),
                                    blurRadius: 10.0,
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text("Mohon Tunggu"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : Center(),
              ],
            ),
    );
  }

  Future LogOut() async {
    return await _auth.signOut();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<DataSnapshot> getRole() async {
    return FirebaseDatabase.instance
        .reference()
        .child("USER")
        .child(uid)
        .once();
  }
}
