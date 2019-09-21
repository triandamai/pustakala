import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/signin_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool Login_Screen = true;
  String email;

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((user) {
      if (user != null) {
        setState(() {
          Login_Screen = false;
          email = user.email;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Login_Screen) {
      return Container(
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
      );
    } else {
      return Scaffold(
        body: SafeArea(
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
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                  Text(
                    "$email",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Text("Ubah Foto Profil"),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/add');
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
                          "Tambah Produk",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      LogOut();
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
      );
    }
  }

  void LogOut() async {
    await _auth.signOut();
    setState(() {
      Login_Screen = false;
    });
  }
}
