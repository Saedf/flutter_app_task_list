import 'package:bloc/bloc.dart';
import 'package:flutter_app_task_list/data/data.dart';
import 'package:flutter_app_task_list/data/repo/repository.dart';
import 'package:meta/meta.dart';

part 'edittask_state.dart';

class EdittaskCubit extends Cubit<EdittaskState> {
  final TaskEntity _taskEntity;
  final Repository<TaskEntity> repository;
  EdittaskCubit(this._taskEntity, this.repository)
      : super(EdittaskInitial(_taskEntity));

  void onSaveChagesClick() {
    repository.createOrUpdate(_taskEntity);
  }

  void onTextChanged(String task) {
    _taskEntity.name = task;
  }

  void onPriorityChange(Priority priorityTask) {
    _taskEntity.priority = priorityTask;
    emit(EditTaskPriorityChange(_taskEntity));
  }
}
