import 'package:Pustakala/src/screens/main.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pages/signup_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _progressActive = true;
  bool _toggleVisibility = true;
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _progressActive = false;
    });
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      controller: _email,
      decoration: InputDecoration(
        hintText: "Your email or username",
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40, left: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 100.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Forgotten Password?",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Card(
                      elevation: 5.0,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(
                              height: 20.0,
                            ),
                            _buildPasswordTextField(),
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
                          _progressActive = true;
                        });
                        _signIn().then((user) {
                          if (user != null) {
                            Fluttertoast.showToast(
                                msg: "Login Berhasil",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.green[500],
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          } else {
                            setState(() {
                              _progressActive = false;
                            });
                            Fluttertoast.showToast(
                                msg: "Login Gagal",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIos: 1,
                                backgroundColor: Colors.red[500],
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          }
                        }).catchError((err) {
                          print("Error ${err.toString()}");
                          setState(() {
                            _progressActive = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Login Gagal",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIos: 1,
                              backgroundColor: Colors.red[500],
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()));
                        });
                      },
                      child: Container(
                        height: 50.0,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25.0)),
                        child: Center(
                          child: Text(
                            "Sign In",
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
                          "Don't have an account?",
                          style: TextStyle(
                              color: Color(0xFFBDC2CB),
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SignUpPage()));
                          },
                          child: Text(
                            "Sign up",
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
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  Future<FirebaseUser> _signIn() async {
    return (await _auth.signInWithEmailAndPassword(
            email: _email.text, password: _pass.text))
        .user;
  }
}
