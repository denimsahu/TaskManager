import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskUsecase {
  final TaskRepository taskRepository;
  
  AddTaskUsecase({required this.taskRepository});

  Future<void> call({
    required String title,
    required PriorityEnum priority,
    required String? description,
    required DateTime? dueDate,
    required bool isCompleted,
  })async {
    String id =Uuid().v4();
      await taskRepository.addTask(taskEntity: TaskEntity(id: id, title: title, priority: priority, description: description, dueDate: dueDate, isCompleted: isCompleted));
  }

}