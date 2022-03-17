part of 'tasklist_bloc.dart';

@immutable
abstract class TasklistEvent {}

class TaskListStarted extends TasklistEvent {}

class TaskListSearch extends TasklistEvent {
  final String searchTerm;

  TaskListSearch(this.searchTerm);
}

class TaskListDeleteAll extends TasklistEvent {}
