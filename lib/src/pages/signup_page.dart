import 'package:Pustakala/src/pages/signin_page.dart';
import 'package:Pustakala/src/screens/main.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _toggleVisibility = true;
  bool _toggleConfirmVisibility = true;

  TextEditingController _nama = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _repass = TextEditingController();
  bool _progressActive = true;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _progressActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Stack(children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Card(
                elevation: 5.0,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      _buildUsernameTextField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildConfirmPasswordTextField(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    this._progressActive = true;
                  });
                  signUpWithEmail().then((user) {
                    if (user != null) {
                      FirebaseDatabase.instance
                          .reference()
                          .child("USER")
                          .child("${user.uid}")
                          .set({
                        'nama': _nama.text,
                        'uid': '${user.uid}',
                        'email': _email.text,
                        'foto': "",
                      }).then((_) {
                        print("tersimpan");
                        setState(() {
                          this._progressActive = false;
                        });
                        Fluttertoast.showToast(
                            msg: "Register Berhasil",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.green[500],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => MainScreen()));
                      });
                    } else {
                      setState(() {
                        this._progressActive = false;
                      });
                      Fluttertoast.showToast(
                          msg: "Register Gagal",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red[500],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  }).catchError((err) {
                    setState(() {
                      _progressActive = false;
                    });
                    Fluttertoast.showToast(
                        msg: "Gagal Mendaftar",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red[500],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                },
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(25.0)),
                  child: Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Divider(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                  SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) => SignInPage()));
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _progressActive
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
      ]),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _email,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _buildUsernameTextField() {
    return TextFormField(
      controller: _nama,
      decoration: InputDecoration(
        hintText: "Username",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      controller: _pass,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _toggleVisibility = !_toggleVisibility;
            });
          },
          icon: _toggleVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
      ),
      obscureText: _toggleVisibility,
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return TextFormField(
      controller: _repass,
      decoration: InputDecoration(
        hintText: "Confirm Password",
        hintStyle: TextStyle(
          color: Color(0xFFBDC2CB),
          fontSize: 18.0,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _toggleConfirmVisibility = !_toggleConfirmVisibility;
            });
          },
          icon: _toggleConfirmVisibility
              ? Icon(Icons.visibility_off)
              : Icon(Icons.visibility),
        ),
      ),
      obscureText: _toggleConfirmVisibility,
    );
  }

  bool cek_validasi() {
    if (_nama.text.isEmpty ||
        _email.text.isEmpty ||
        _pass.text.isEmpty ||
        _repass.text.isEmpty ||
        _pass.text != _repass.text) {
      return false;
    } else {
      return true;
    }
  }

  bool cek_panjang() {
    if (_pass.text.length <= 6) {
      return false;
    } else {
      return true;
    }
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> signUpWithEmail() async {
    return await (await _auth.createUserWithEmailAndPassword(
            email: _email.text, password: _pass.text))
        .user;
  }
}
