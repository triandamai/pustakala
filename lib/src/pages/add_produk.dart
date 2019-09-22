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
  TextEditingController _judul = TextEditingController();
  TextEditingController _deskripsi = TextEditingController();
  TextEditingController _harga = TextEditingController();
  TextEditingController _rating = TextEditingController();
  TextEditingController _halaman = TextEditingController();
  TextEditingController _penulis = TextEditingController();
  TextEditingController _chapter = TextEditingController();
  TextEditingController _diskon = TextEditingController();

  bool _progressActive = false;
  bool fileIsPicked = false;
  File _image, _file;
  String _uploadedFileURL;
  String _uoloadedImageUrl;
  String dropdownValue = 'Pilih Kategori';
  FirebaseAuth _auth = FirebaseAuth.instance;

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
      appBar: AppBar(
        title: Text("tambah barang"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
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
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(0.0)),
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
                  TextFormField(
                    controller: _judul,
                    decoration: InputDecoration(
                      hintText: "Judul Buku",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _halaman,
                    decoration: InputDecoration(
                      hintText: "Jumlah halaman",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _harga,
                    decoration: InputDecoration(
                      hintText: "Harga Buku",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _deskripsi,
                    decoration: InputDecoration(
                      hintText: "Deskripsi Buku",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _diskon,
                    decoration: InputDecoration(
                      hintText: "Diskon Buku",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _penulis,
                    decoration: InputDecoration(
                      hintText: "Nama Penulis",
                      hintStyle: TextStyle(
                        color: Color(0xFFBDC2CB),
                        fontSize: 18.0,
                      ),
                    ),
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
                        setState(() {
                          this._progressActive = true;
                        });
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
    );
  }

  bool val() {
    return _judul.text.isEmpty ||
        _deskripsi.text.isEmpty ||
        _halaman.text.isEmpty ||
        _harga.text.isEmpty ||
        _diskon.text.isEmpty ||
        _penulis.text.isEmpty ||
        _image == null ||
        dropdownValue == "Pilih Kategori";
  }

  Future addProduk() async {
    FirebaseUser user = await _auth.currentUser();

    Book book = new Book(
        name: _judul.text,
        imagePath: _uoloadedImageUrl,
        rating: 0,
        harga: int.parse(_harga.text),
        diskon: int.parse(_diskon.text),
        category: dropdownValue,
        chapter: _chapter.text,
        deskripsi: _deskripsi.text,
        halaman: int.parse(_halaman.text),
        penulis: _penulis.text);
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
        setState(() {
          _progressActive = false;
          _penulis.clear();
          _diskon.clear();
          _deskripsi.clear();
          _harga.clear();
          _judul.clear();
          _halaman.clear();
          _chapter.clear();
          _image = null;
        });
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
