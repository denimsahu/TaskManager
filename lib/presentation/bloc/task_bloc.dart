import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/usecases/add_task_usecase.dart';
import 'package:task_manager/domain/usecases/all_task_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // GetAllTaskUsecase getAllTaskUsecase;
  TaskBloc({required GetAllTaskUsecase getAllTaskUsecase, required AddTaskUsecase addTaskUsecase}) : super(TaskInitial()) {
  
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

  }
}
