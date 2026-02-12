import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class GetAllTaskUsecase{
  
  TaskRepository taskRepository;
  GetAllTaskUsecase({required this.taskRepository});

  Future<List<TaskEntity>> call() async {

    return await taskRepository.getAllTask();
  }
}