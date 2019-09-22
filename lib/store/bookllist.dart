import 'package:Pustakala/src/models/minat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mobx/mobx.dart';

import 'minat.dart';

part 'bookllist.g.dart';

class BookList = _BookList with _$BookList;

abstract class _BookList with Store {
  @observable
  ObservableList<UserMinat> _books = ObservableList<UserMinat>();

  @action
  void remove(Event event) {
    _books.remove(event.snapshot);
  }

  @action
  void addNew(UserMinat book) {
    _books.add(book);
  }

  @computed
  ObservableList<UserMinat> get getListBook {
    return _books;
  }
}
