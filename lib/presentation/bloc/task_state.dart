part of 'task_bloc.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

class LoadingTaskState extends TaskState{}

class EmptyTaskState extends TaskState{}

class LoadedTaskState extends TaskState{
  final List<TaskEntity> allTasks;
  LoadedTaskState({required this.allTasks});
}

class ErrorTaskState extends TaskState{}