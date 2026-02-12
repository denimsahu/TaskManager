import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data/datasource/task_local_data_source.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repository/task_repository_impl.dart';
import 'package:task_manager/domain/usecases/all_task_usecase.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';
import 'package:task_manager/presentation/screens/list_task_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  Box<TaskModel> tasksBox = await Hive.openBox<TaskModel>('Tasks');
  GetAllTaskUsecase getAllTaskUsecase = GetAllTaskUsecase(taskRepository: TaskRepositoryImpl(taskLocalDataSource: TaskLocalDataSource(taskBox: tasksBox)));
  runApp(MyApp(getAllTaskUsecase: getAllTaskUsecase,));
}

class MyApp extends StatelessWidget {
  final GetAllTaskUsecase getAllTaskUsecase;
  const MyApp({super.key,required this.getAllTaskUsecase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context)=> TaskBloc(getAllTaskUsecase:getAllTaskUsecase),),
      ], 
      child: MaterialApp(
        routes: {
          "/":(context)=>const ListTaskScreen(),
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
