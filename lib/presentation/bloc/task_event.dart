part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadAllTaskEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent{

  String title;
  String priority;
  String? description;
  DateTime? dueDate;
  bool isCompleted;
  
  AddTaskEvent({
    required this.title,
    required this.priority,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });
  
}