import 'package:firebase_database/firebase_database.dart';

class Book {
  final String name;
  final String id;
  final String imagePath;
  final String category;
  final int harga;
  final int diskon;
  final int rating;
  final String deskripsi;
  final int halaman;
  final String penulis;
  final String chapter;

  Book(
      {this.id,
      this.name,
      this.imagePath,
      this.category,
      this.harga,
      this.diskon,
      this.rating,
      this.deskripsi,
      this.chapter,
      this.halaman,
      this.penulis});

  Book.fromSnapshot(DataSnapshot dataSnapshot)
      : id = dataSnapshot.key,
        name = dataSnapshot.value["name"],
        imagePath = dataSnapshot.value["imagePath"],
        category = dataSnapshot.value["category"],
        harga = dataSnapshot.value["harga"],
        diskon = dataSnapshot.value["diskon"],
        rating = dataSnapshot.value["rating"],
        chapter = dataSnapshot.value["chapter"],
        halaman = dataSnapshot.value["halaman"],
        penulis = dataSnapshot.value["penulis"],
        deskripsi = dataSnapshot.value["deskripsi"];
  toJson() {
    return {
      "name": name,
      "imagePath": imagePath,
      "category": category,
      "harga": harga,
      "diskon": diskon,
      "rating": rating,
      "deskripsi": deskripsi,
      "halaman": halaman,
      "penulis": penulis,
      "chapter": chapter,
    };
  }
}
