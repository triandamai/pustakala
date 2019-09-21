import 'dart:io';

import 'package:Pustakala/src/models/book_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

class AddProduk extends StatefulWidget {
  @override
  _AddProdukState createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  String _judul = "",
      _deskripsi = "",
      _harga = "",
      _rating,
      _halaman = "",
      _penulis = "",
      _chapter = "",
      _diskon = "";
  bool fileIsPicked = false;
  File _image, _file;
  String _uploadedFileURL;
  String _uoloadedImageUrl;
  String dropdownValue = 'Pilih Kategori';
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tambah barang"),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: _image == null
                    ? Text(
                        "Gagal mengambil gambar",
                        textAlign: TextAlign.center,
                      )
                    : new Container(
                        height: 160.0,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: new DecorationImage(
                            image: new ExactAssetImage(_image.path),
                            fit: BoxFit.contain,
                          ),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(0.0)),
                        ),
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Pilih Kategori',
                      'Edukasi',
                      'Biografi',
                      'Sejarah & Budaya',
                      'Majalah',
                      'Surat Kabar'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      chooseImage(ImageSource.gallery);
                    },
                    icon: Icon(Icons.add),
                    label: Text("Pilih gambar"),
                  ),
                ],
              ),
              TextField(
                onChanged: (val) {
                  _judul = val;
                },
                decoration: InputDecoration(hintText: "Judul"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  _halaman = val;
                },
                decoration: InputDecoration(hintText: "Jumlah Halaman"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  _harga = val;
                },
                decoration: InputDecoration(
                  hintText: "Harga Buku",
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  _deskripsi = val;
                },
                decoration: InputDecoration(hintText: "Deskripsi"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  _diskon = val;
                },
                decoration: InputDecoration(hintText: "Diskon"),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                onChanged: (val) {
                  _penulis = val;
                },
                decoration: InputDecoration(hintText: "Penulis"),
              ),
              RaisedButton.icon(
                onPressed: () {
                  if (val()) {
                    Fluttertoast.showToast(
                        msg: "Mohon Isi Semua Field",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red[500],
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    uploadFile();
                  }
                },
                icon: Icon(Icons.add),
                label: Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool val() {
    return _judul.isEmpty ||
        _deskripsi.isEmpty ||
        _halaman.isEmpty ||
        _harga.isEmpty ||
        _diskon.isEmpty ||
        _penulis.isEmpty ||
        _image == null ||
        dropdownValue == "Pilih Kategori";
  }

  Future addProduk() async {
    FirebaseUser user = await _auth.currentUser();

    Book book = new Book(
        name: _judul,
        imagePath: _uoloadedImageUrl,
        rating: 0,
        harga: int.parse(_harga),
        diskon: int.parse(_diskon),
        category: dropdownValue,
        chapter: _chapter,
        deskripsi: _deskripsi,
        halaman: int.parse(_halaman),
        penulis: _penulis);
    FirebaseDatabase.instance
        .reference()
        .child("BUKU")
        .push()
        .set(book.toJson());
  }

  Future chooseImage(ImageSource source) async {
    await ImagePicker.pickImage(source: source).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future chooseFile() async {
    await FilePicker.getFile(type: FileType.ANY).then((file) {
      setState(() {
        _file = file;
      });
    });
  }

  Future uploadFile() async {
    var date = DateTime.now().millisecondsSinceEpoch;
    String timestamp = date.toString();

    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('Images/$timestamp.jpeg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

//    StorageReference storageReferenceFile =
//        FirebaseStorage.instance.ref().child("Files/$timestamp.pdf");
//    StorageUploadTask uploadTaskFile = storageReferenceFile.putFile(_file);

    await uploadTask.onComplete;
//    await uploadTaskFile.onComplete;

    print('Image Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uoloadedImageUrl = fileURL;
      });
      addProduk().then((_) {
        Fluttertoast.showToast(
            msg: "Berhasil menyimpan ${_judul}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIos: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    });
//    print('File Uploaded');
//    storageReferenceFile.getDownloadURL().then((fileUrl) {
//      setState(() {
//        _uploadedFileURL = fileUrl;
//      });

//    });
  }
}
