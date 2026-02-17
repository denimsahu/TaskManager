import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class EditTaskUsecase {
  final TaskRepository taskRepository;
  EditTaskUsecase({required this.taskRepository});

  Future<void> call({required TaskEntity taskEntity}) async {
    await taskRepository.editTask(taskEntity:taskEntity);
  }
}