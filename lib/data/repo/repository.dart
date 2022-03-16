import 'package:flutter/foundation.dart';
import 'package:flutter_app_task_list/data/source/source.dart';

class Repository<T> extends ChangeNotifier implements DataSource<T> {
  final DataSource<T> localdatasource;
  //final DataSource<T> remoteDatasource;

  Repository(
    this.localdatasource,
  );
  @override
  Future<T> createOrUpdate(T data) async {
    // TODO: implement createOrUpdate
    final T result = await localdatasource.createOrUpdate(data);
    notifyListeners();
    return result;
  }

  @override
  Future<void> delete(T data) async {
    // TODO: implement delete
    await localdatasource.delete(data);
    notifyListeners();
  }

  @override
  Future<void> deleteAll() async {
    // TODO: implement deleteAll
    await localdatasource.deleteAll();
    notifyListeners();
  }

  @override
  Future<void> deleteById(id) async {
    // TODO: implement deleteById
    await deleteById(id);
    notifyListeners();
  }

  @override
  Future<T> findById(id) {
    // TODO: implement findById
    return localdatasource.findById(id);
  }

  @override
  Future<List<T>> getAll({String searchKeyword = ''}) {
    // TODO: implement getAll
    return localdatasource.getAll(searchKeyword: searchKeyword);
  }
}
