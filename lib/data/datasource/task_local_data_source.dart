import 'package:hive/hive.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/domain/entities/task_entity.dart';

class TaskLocalDataSource {
  final Box<TaskModel> _taskBox;
  
  TaskLocalDataSource({required Box<TaskModel> taskBox}):_taskBox=taskBox;

  Future<List<TaskModel>> getAllTask() async {
    return await _taskBox.values.toList();
  }

  Future<void> addTask({required TaskModel taskModel})async{
    await _taskBox.put(taskModel.id, taskModel);
  }

  Future<void> editTask({required TaskModel taskModel})async{
    await _taskBox.put(taskModel.id, taskModel);
  }

  Future<List<TaskModel>> deleteTask({required TaskModel taskModel})async{
    await _taskBox.delete(taskModel.id);
    return _taskBox.values.toList();
  }

  Future<List<TaskModel>> filterTask({required FilterType filterType})async{
    if(filterType==FilterType.pending){
      return _taskBox.values.where((task){return task.isCompleted==false;}).toList();
    }
    else if (filterType==FilterType.completed){
      return _taskBox.values.where((task){return task.isCompleted==true;}).toList();
    }
    else{
      return _taskBox.values.toList();
    }
  }
}