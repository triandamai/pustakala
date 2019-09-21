import 'package:firebase_database/firebase_database.dart';

class Minat {
  String id_buku, image, judul, harga, key;
  int jumlah;

  Minat(
      {this.key,
      this.id_buku,
      this.image,
      this.judul,
      this.jumlah,
      this.harga});

  Minat.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        id_buku = snapshot.value["id_buku"],
        image = snapshot.value["image"],
        judul = snapshot.value["judul"],
        jumlah = snapshot.value["jumlah"],
        harga = snapshot.value["harga"];

  toJson() {
    return {
      "id_buku": id_buku,
      "image": image,
      "judul": judul,
      "jumlah": jumlah,
      "harga": harga
    };
  }
}
