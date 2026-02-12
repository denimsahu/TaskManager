import 'package:hive/hive.dart';
import 'package:task_manager/domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject{

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  int priority;
  
  @HiveField(3)
  String? description;

  @HiveField(4)
  DateTime? dueDate;
  
  @HiveField(5)
  bool isCompleted;
  
  TaskModel({
    required this.id,
    required this.title,
    required this.priority,
    this.description,
    this.dueDate,
    this.isCompleted=false,
  });

  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      dueDate: dueDate,
      priority: PriorityEnum.values[priority],
      isCompleted: isCompleted,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority.index,
      isCompleted: entity.isCompleted,
    );
  }
}