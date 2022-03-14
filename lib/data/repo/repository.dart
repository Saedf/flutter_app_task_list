import 'package:flutter_app_task_list/data/source/source.dart';

class Repository<T> implements DataSource<T> {
  final DataSource<T> localdatasource;
  //final DataSource<T> remoteDatasource;

  Repository(
    this.localdatasource,
  );
  @override
  Future<T> createOrUpdate(T data) {
    // TODO: implement createOrUpdate
    return localdatasource.createOrUpdate(data);
  }

  @override
  Future<void> delete(T data) {
    // TODO: implement delete
    return localdatasource.delete(data);
  }

  @override
  Future<void> deleteAll() {
    // TODO: implement deleteAll
    return localdatasource.deleteAll();
  }

  @override
  Future<void> deleteById(id) {
    // TODO: implement deleteById
    return deleteById(id);
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
