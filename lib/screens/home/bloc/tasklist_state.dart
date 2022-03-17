part of 'tasklist_bloc.dart';

@immutable
abstract class TasklistState {}

class TasklistInitial extends TasklistState {}

class TaskListLoading extends TasklistState {}

class TaskListSuccess extends TasklistState {
  final List<TaskEntity> items;

  TaskListSuccess(this.items);
}

class TaskListEmpty extends TasklistState {}

class TaskListError extends TasklistState {
  final String errorMessage;

  TaskListError(this.errorMessage);
}
