import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/usecases/add_task_usecase.dart';
import 'package:task_manager/domain/usecases/get_all_task_usecase.dart';
import 'package:task_manager/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager/domain/usecases/edit_task_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({required GetAllTaskUsecase getAllTaskUsecase, required AddTaskUsecase addTaskUsecase, required EditTaskUsecase editTaskUsecase, required DeleteTaskUsecase deleteTaskUsecase}) : super(TaskInitial()) {
  
    on<LoadAllTaskEvent>((event, emit) async {
      emit(LoadingTaskState());
      try{
        List<TaskEntity> allTasks = await getAllTaskUsecase.call();
        if(allTasks.isEmpty){
          emit(EmptyTaskState());
        }
        else{
          emit(LoadedTaskState(allTasks:allTasks));
        }
      }
      catch(error){
        emit(ErrorTaskState(message: error.toString()));
        print(error.toString());
      }
    });

    on<AddTaskEvent>((event, emit) async {
      try{
        await addTaskUsecase.call(title: event.title, priority: event.priority, description: event.description, dueDate: event.dueDate, isCompleted: event.isCompleted);
        emit(TaskAddedState());
      }
      catch(error){
        print("--------------------------");
        ErrorTaskState(message: error.toString());
      }
    });

  on<EditTaskEvent>((event, emit) async {
    try{
      await editTaskUsecase.call(taskEntity: TaskEntity(id: event.id, title: event.title, priority: event.priority, description: event.description, dueDate: event.dueDate, isCompleted: event.isCompleted));
      List<TaskEntity> allTasks = await getAllTaskUsecase.call();
      emit(TaskUpdatedState());
      emit(LoadedTaskState(allTasks:allTasks));
    }
    catch(error){
      print("--------------------------");
      ErrorTaskState(message: error.toString());
    }
  });

  on<DeleteTaskEvent>((event, emit) async {
    try{
      await deleteTaskUsecase.deleteTask(taskEntity: event.taskEntity);
      emit(TaskDeletedState());
    }
    catch(error){
      print("--------------------------");
      ErrorTaskState(message: error.toString());
    }
  });

  }
}
