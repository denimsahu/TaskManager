import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/usecases/all_task_usecase.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  GetAllTaskUsecase getAllTaskUsecase;
  TaskBloc({required this.getAllTaskUsecase}) : super(TaskInitial()) {
    on<LoadAllTaskEvent>((event, emit) async {
      emit(LoadingTaskState());
      try{
        List<TaskEntity> allTasks = await getAllTaskUsecase.call();
        await Future.delayed(Duration(seconds: 3));
        if(allTasks.isEmpty){
          emit(EmptyTaskState());
        }
        else{
          emit(LoadedTaskState(allTasks:allTasks));
        }
      }
      catch(error){
        emit(ErrorTaskState());
        print(error.toString());
      }
    });
  }
}
