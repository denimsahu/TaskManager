import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';

class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  @override
  void initState() {
    context.read<TaskBloc>().add(LoadAllTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state is LoadingTaskState){
              print("Loading....");
              return CircularProgressIndicator();
            }
            else if (state is EmptyTaskState){
              print("Empty");
              return Icon(Icons.hourglass_empty);
            }
            else if(state is ErrorTaskState){
              // print("Error");
              return Icon(Icons.error);
            }
            else if (state is LoadedTaskState){
              return Text("Task 1");
            }
            return Text("Hello World!!");
          },
        ),
      ),
    );
  }
}
