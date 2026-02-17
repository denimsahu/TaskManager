part of 'task_bloc.dart';

@immutable
sealed class TaskEvent {}

class LoadAllTaskEvent extends TaskEvent {}

class AddTaskEvent extends TaskEvent{

  String title;
  PriorityEnum priority;
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

class EditTaskEvent extends TaskEvent{
  String id;
  String title;
  PriorityEnum priority;
  String? description;
  DateTime? dueDate;
  bool isCompleted;
  
  EditTaskEvent({
    required this.id,
    required this.title,
    required this.priority,
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  }); 
}

class FilterTaskEvent extends TaskEvent{
  FilterType filterType;
  FilterTaskEvent({required this.filterType});
}

class DeleteTaskEvent extends TaskEvent{
  TaskEntity taskEntity;
  DeleteTaskEvent({required this.taskEntity});
}