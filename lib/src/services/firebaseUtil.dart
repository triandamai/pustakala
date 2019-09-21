//import 'dart:async';
//
//import 'package:Pustakala/src/models/book_model.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
//
//class FirebaseDatabaseUtil {
//  DatabaseReference _counterRef;
//  DatabaseReference _bukuRef, _minatRef, _pesananRef;
//  StreamSubscription<Event> _counterSubscription;
//  StreamSubscription<Event> _messagesSubscription;
//  FirebaseDatabase database = new FirebaseDatabase();
//  FirebaseAuth _auth;
//  FirebaseUser user;
//  int _counter;
//  DatabaseError error;
//
//  static final FirebaseDatabaseUtil _instance =
//      new FirebaseDatabaseUtil.internal();
//
//  FirebaseDatabaseUtil.internal();
//
//  factory FirebaseDatabaseUtil() {
//    return _instance;
//  }
//
//  void initState() async {
//    _auth = FirebaseAuth.instance;
//    user = await _auth.currentUser();
//
//    // Demonstrates configuring to the database using a file
//    // _counterRef = FirebaseDatabase.instance.reference().child('counter');
//    // Demonstrates configuring the database directly
//
//    //_userRef = database.reference().child('user');
//    _minatRef =
//        FirebaseDatabase.instance.reference().child("MINAT").child(user.uid);
//    _pesananRef = database.reference().child("PESANAN").child(user.uid);
//    _bukuRef = database.reference().child("BUKU");
//
//    database.reference().child('counter').once().then((DataSnapshot snapshot) {
//      print('Connected to second database and read ${snapshot.value}');
//    });
//    database.setPersistenceEnabled(true);
//    database.setPersistenceCacheSizeBytes(10000000);
//    //_counterRef.keepSynced(true);
//
////
////    _counterSubscription = _counterRef.onValue.listen((Event event) {
////      error = null;
////      _counter = event.snapshot.value ?? 0;
////    }, onError: (Object o) {
////      error = o;
////    });
//  }
//
//  DatabaseError getError() {
//    return error;
//  }
//
//  int getCounter() {
//    return _counter;
//  }
//
//  DatabaseReference getBook() {
//    return _bukuRef;
//  }
//
//  DatabaseReference getMinat() {
//    return _minatRef;
//  }
//
//  DatabaseReference getPesanan() {
//    return _pesananRef;
//  }
//
//  addBook(Book book) async {
//    final TransactionResult transactionResult =
//        await _counterRef.runTransaction((MutableData mutableData) async {
//      mutableData.value = (mutableData.value ?? 0) + 1;
//
//      return mutableData;
//    });
//
//    if (transactionResult.committed) {
//      _bukuRef.push().set(<String, String>{
//        "name": book.name,
//        "imagePath": book.imagePath,
//        "category": book.category,
//        "harga": book.harga,
//        "diskon": book.diskon,
//        "rating": book.rating,
//        "deskripsi": book.deskripsi,
//      }).then((_) {
//        print('Transaction  committed.');
//      });
//    } else {
//      print('Transaction not committed.');
//      if (transactionResult.error != null) {
//        print(transactionResult.error.message);
//      }
//    }
//  }
//
//  void deleteBook(Book book) async {
//    await _bukuRef.child(book.id).remove().then((_) {
//      print('Transaction  committed.');
//    });
//  }
//
//  void updateBook(Book book) async {
//    await _bukuRef.child(book.id).update({
//      "name": book.name,
//      "imagePath": book.imagePath,
//      "category": book.category,
//      "harga": book.harga,
//      "diskon": book.diskon,
//      "rating": book.rating,
//      "deskripsi": book.deskripsi,
//    }).then((_) {
//      print('Transaction  committed.');
//    });
//  }
//
//  void dispose() {
//    _messagesSubscription.cancel();
//    _counterSubscription.cancel();
//  }
//}
