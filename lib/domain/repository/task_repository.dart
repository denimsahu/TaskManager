import 'package:task_manager/domain/entities/task_entity.dart';

abstract interface class  TaskRepository{
  Future<List<TaskEntity>> getAllTask();
}