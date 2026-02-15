import 'package:task_manager/domain/entities/task_entity.dart';

abstract interface class  TaskRepository{
  Future<List<TaskEntity>> getAllTask();
  Future<void> addTask({required TaskEntity taskEntity});
  Future<void> editTask ({required TaskEntity taskEntity});
  Future<void> deleteTask({required TaskEntity taskEntity});
}