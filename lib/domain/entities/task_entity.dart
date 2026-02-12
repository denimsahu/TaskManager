enum PriorityEnum {low, medium, high}

class TaskEntity {
  String id;
  String title;
  PriorityEnum priority;
  DateTime? dueDate;
  bool isCompleted;
  String? description;

  TaskEntity({
    required this.id,
    required this.title,
    required this.priority,
    this.description,
    this.dueDate,
    this.isCompleted=false,
  });
}