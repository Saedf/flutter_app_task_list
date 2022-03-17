import 'package:bloc/bloc.dart';
import 'package:flutter_app_task_list/data/data.dart';
import 'package:flutter_app_task_list/data/repo/repository.dart';
import 'package:meta/meta.dart';

part 'tasklist_event.dart';
part 'tasklist_state.dart';

class TasklistBloc extends Bloc<TasklistEvent, TasklistState> {
  final Repository<TaskEntity> repository;
  TasklistBloc(this.repository) : super(TasklistInitial()) {
    on<TasklistEvent>((event, emit) async {
      final String searchTerm;

      if (event is TaskListStarted || event is TaskListSearch) {
        emit(TaskListLoading());

        if (event is TaskListSearch) {
          searchTerm = event.searchTerm;
        } else {
          searchTerm = '';
        }

        try {
          // throw Exception('test');
          final items = await repository.getAll(searchKeyword: searchTerm);
          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('خطای نانشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
