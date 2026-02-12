import 'package:hive/hive.dart';
import 'package:task_manager/data/models/task_model.dart';

class TaskLocalDataSource {
  final Box<TaskModel> _taskBox;
  
  TaskLocalDataSource({required Box<TaskModel> taskBox}):_taskBox=taskBox;

  Future<List<TaskModel>> getAllTask() async {
    
    return await _taskBox.values.toList();
  }
}