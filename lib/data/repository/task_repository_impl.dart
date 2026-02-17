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
    return taskModels.map((model){return model.toEntity();}).toList().reversed.toList();
  }

  @override
  Future<void> addTask({required TaskEntity taskEntity}) async {
    _taskLocalDataSource.addTask(taskModel: TaskModel.fromEntity(taskEntity));
  }

  @override
  Future<void> editTask({required TaskEntity taskEntity}) async {
    await _taskLocalDataSource.editTask(taskModel:TaskModel.fromEntity(taskEntity));
  }
  
  @override
  Future<List<TaskEntity>> deleteTask({required TaskEntity taskEntity}) async {
    List<TaskModel> taskModels = await _taskLocalDataSource.deleteTask(taskModel: TaskModel.fromEntity(taskEntity));
    return taskModels.map((model){return model.toEntity();}).toList().reversed.toList();
  }

  @override
  Future<List<TaskEntity>> filterTask({required FilterType filterType})async{
    List<TaskModel> filteredTask = await _taskLocalDataSource.filterTask(filterType:filterType);
    return filteredTask.map((model){return model.toEntity();}).toList().reversed.toList();
  }
}