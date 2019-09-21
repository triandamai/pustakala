import 'package:Pustakala/src/pages/signin_page.dart';
import 'package:Pustakala/src/screens/main.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _toggleVisibility = true;
  bool _toggleConfirmVisibility = true;
  String _nama, _email, _pass, _repass;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseDatabase _database = FirebaseDatabase.instance;

  Widget _buildEmailTextField() {
    return TextFormField(
      onChanged: (val) {
        _email = val;
      },
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
      onChanged: (val) {
        _nama = val;
      },
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
      onChanged: (val) {
        _pass = val;
      },
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
      onChanged: (val) {
        _repass = val;
      },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Padding(
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
                signUpWithEmail();
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
    );
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  void signUpWithEmail() async {
    try {
      final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: _email, password: _pass))
          .user;
      if (user != null) {
        //berhasil
        print("register berhasil");
        FirebaseUser user = await _auth.currentUser();
        FirebaseDatabase.instance
            .reference()
            .child("USER")
            .child("${user.uid}")
            .set({
          'nama': _nama,
          'uid': '${user.uid}',
          'email': _email,
          'foto': "",
        }).then((_) {
          print("tersimpan");
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()));
        });
      } else {
        //gagal
        print("login gagal");
        setState(() {
          _email = "";
          _pass = "";
          _repass = "";
          _nama = "";
        });
      }
    } catch (e) {
      print("error ${e.toString()}");
    }
  }
}
