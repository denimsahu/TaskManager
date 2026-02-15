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
              return ListView.builder(
                itemBuilder: (context,index){
                  bool isCompleted = state.allTasks[index].isCompleted;
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("/task_screen",arguments: state.allTasks[index],);
                    },
                    child: ListTile(
                      title: Text(state.allTasks[index].title),
                      subtitle: Text(state.allTasks[index].priority.name),
                      trailing: Checkbox(
                        value: isCompleted,
                        onChanged: (value){
                          context.read<TaskBloc>().add(EditTaskEvent(id: state.allTasks[index].id, title: state.allTasks[index].title, priority: state.allTasks[index].priority, description: state.allTasks[index].description, dueDate: state.allTasks[index].dueDate, isCompleted: value!));
                        }
                      ),
                    ),
                  );
                },
                itemCount: state.allTasks.length,
                );
            }
            return Text("Hello World!!");
          },
        ),
      ),
    floatingActionButton: FloatingActionButton(
      onPressed: (){
        Navigator.of(context).pushNamed("/task_screen");
      }, 
      child: Icon(Icons.add),
      ),
    );
  }
}
