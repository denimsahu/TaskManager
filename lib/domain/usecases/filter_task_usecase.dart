import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class FilterTaskUsecase {
  TaskRepository taskRepository;
  FilterTaskUsecase({required this.taskRepository});

  Future<List<TaskEntity>> call(FilterType filterType) async {
    return await taskRepository.filterTask(filterType:filterType);
  }
}