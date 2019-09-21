import 'package:Pustakala/src/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SearchField extends StatelessWidget {
  TextEditingController _kata = TextEditingController(text: "");
  String que;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      child: TextField(
        controller: _kata,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 32.0, vertical: 14.0),
          hintText: "Cari buku...",
          suffixIcon: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              child: InkWell(
                onTap: () {
                  if (_kata.text == null ||
                      _kata.text == "" ||
                      _kata.text.length <= 1) {
                    Fluttertoast.showToast(
                        msg: "Masukkan kata kunci terlebbih dahulu",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          query: _kata.text,
                        ),
                      ),
                    );
                  }
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              )),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
