import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data/datasource/task_local_data_source.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repository/task_repository_impl.dart';
import 'package:task_manager/domain/usecases/add_task_usecase.dart';
import 'package:task_manager/domain/usecases/filter_task_usecase.dart';
import 'package:task_manager/domain/usecases/get_all_task_usecase.dart';
import 'package:task_manager/domain/usecases/delete_task_usecase.dart';
import 'package:task_manager/domain/usecases/edit_task_usecase.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';
import 'package:task_manager/presentation/screens/task_screen.dart';
import 'package:task_manager/presentation/screens/list_task_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Box<TaskModel> tasksBox = await Hive.openBox<TaskModel>('Tasks');
  TaskRepositoryImpl taskRepositoryImpl = TaskRepositoryImpl(taskLocalDataSource: TaskLocalDataSource(taskBox: tasksBox));
  runApp(MyApp(taskRepositoryImpl: taskRepositoryImpl,));
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl taskRepositoryImpl;
  const MyApp({super.key,required this.taskRepositoryImpl});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context){ 
            return TaskBloc(
              getAllTaskUsecase:GetAllTaskUsecase(taskRepository: taskRepositoryImpl),
              addTaskUsecase: AddTaskUsecase(taskRepository:taskRepositoryImpl),
              editTaskUsecase: EditTaskUsecase(taskRepository: taskRepositoryImpl),
              deleteTaskUsecase: DeleteTaskUsecase(taskRepository: taskRepositoryImpl),
              filterTaskUsecase: FilterTaskUsecase(taskRepository: taskRepositoryImpl),
            );
          }
        ),
      ], 
      child: MaterialApp(
        routes: {
          "/":(context)=>const ListTaskScreen(),
          "/task_screen":(context)=>const TaskScreen(),
        },
        title: 'Task Manager',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
      ),
    );
  }
}
