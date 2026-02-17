enum PriorityEnum {low, medium, high}
enum FilterType { all, completed, pending }

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
    required this.description,
    required this.dueDate,
    required this.isCompleted,
  });
}