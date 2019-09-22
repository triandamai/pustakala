import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

part 'minat.g.dart';

class UserMinat = _UserMinat with _$UserMinat;

abstract class _UserMinat with Store {
  @observable
  String id_buku;
  @observable
  String image;
  @observable
  String judul;
  @observable
  String harga;
  @observable
  String key;
  @observable
  int jumlah;

  _UserMinat(
      {this.key,
      this.id_buku,
      this.image,
      this.judul,
      this.jumlah,
      this.harga});

  _UserMinat.fromSnapshot(DataSnapshot snapshot)
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
