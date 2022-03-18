part of 'edittask_cubit.dart';

@immutable
abstract class EdittaskState {
  final TaskEntity task;

  const EdittaskState(this.task);
}

class EdittaskInitial extends EdittaskState {
  const EdittaskInitial(TaskEntity task) : super(task);
}

class EditTaskPriorityChange extends EdittaskState {
  const EditTaskPriorityChange(TaskEntity task) : super(task);
}
