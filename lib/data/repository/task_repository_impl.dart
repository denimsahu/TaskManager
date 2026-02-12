import 'package:task_manager/data/datasource/task_local_data_source.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/repository/task_repository.dart';

class TaskRepositoryImpl implements TaskRepository {
  late TaskLocalDataSource _taskLocalDataSource;
  TaskRepositoryImpl({required TaskLocalDataSource taskLocalDataSource}):_taskLocalDataSource=taskLocalDataSource;

  @override
  Future<List<TaskEntity>> getAllTask() async {
    List<TaskModel> taskModels = await _taskLocalDataSource.getAllTask();
    return taskModels.map((model){return model.toEntity();}).toList();
  }
}