part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

class LoadingTaskState extends TaskState{}

class EmptyTaskState extends TaskState{}

class LoadedTaskState extends TaskState{
  final List<TaskEntity> tasksList;
  LoadedTaskState({required this.tasksList});
}

class TaskAddedState extends TaskState{}

class TaskUpdatedState extends TaskState{}

class TaskDeletedState extends TaskState{}

class ErrorTaskState extends TaskState{
  final String message;
  ErrorTaskState({required this.message});
}