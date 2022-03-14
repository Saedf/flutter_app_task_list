import 'package:flutter_app_task_list/data/data.dart';
import 'package:flutter_app_task_list/data/source/source.dart';
import 'package:hive/hive.dart';

class HiveTaskDataSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveTaskDataSource(this.box);
  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async {
    // TODO: implement createOrUpdate
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntity data) async {
    // TODO: implement delete
    // return box.delete(data.id);
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    // TODO: implement deleteAll
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    // TODO: implement deleteById
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    // TODO: implement findById
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyword = ''}) async {
    // TODO: implement getAll
    return box.values.toList();
  }
}
