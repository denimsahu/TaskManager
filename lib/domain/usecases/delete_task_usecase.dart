import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class DeleteTaskUsecase {
  TaskRepository taskRepository;
  DeleteTaskUsecase({required this.taskRepository});
  
  Future<void> deleteTask({required TaskEntity taskEntity})async{
    await taskRepository.deleteTask(taskEntity: taskEntity);
  }
}