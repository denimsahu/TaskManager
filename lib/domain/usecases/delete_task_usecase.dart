import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class DeleteTaskUsecase {
  TaskRepository taskRepository;
  DeleteTaskUsecase({required this.taskRepository});
  
  Future<List<TaskEntity>> call({required TaskEntity taskEntity})async{
    return taskRepository.deleteTask(taskEntity: taskEntity);
  }
}