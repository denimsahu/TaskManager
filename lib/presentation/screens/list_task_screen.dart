import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';


class ListTaskScreen extends StatefulWidget {
  const ListTaskScreen({super.key});

  @override
  State<ListTaskScreen> createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {

  FilterType _selectedFilter = FilterType.all;



  @override
  void initState() {
    context.read<TaskBloc>().add(LoadAllTaskEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50,
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return SearchAnchor(
                suggestionsBuilder: (context, controller) {
                  if(state is LoadedTaskState){
                    final query = controller.text.toLowerCase();
                    if (query.isEmpty) return const <Widget>[];
                    final suggestions= state.tasksList.where((task)=>task.title.toLowerCase().contains(query)).toList();
                    return suggestions.map((task){
                      return ListTile(
                        title: Text(task.title),
                        onTap: () {
                          controller.closeView(task.title);
                          controller.clear();
                          Navigator.pushNamed(context,"/task_screen",arguments: task,);
                        },
                      );
                    }).toList();
                  }
                  else{
                    return const <Widget>[]; 
                  }
                },
                builder: (context, controller) {
                  return SearchBar(
                    readOnly: true,
                    hintText: 'Search...',
                    elevation: const WidgetStatePropertyAll(0),
                    leading: const Icon(Icons.search),
                    onTap: () {controller.openView();},
                  );
                },
              );
            },
          ),
        ),
        actions: [
          PopupMenuButton<FilterType>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
              context.read<TaskBloc>().add(FilterTaskEvent(filterType: value));
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: FilterType.all,
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedFilter == FilterType.all,
                      onChanged: null,
                    ),
                    Text("All"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterType.completed,
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedFilter == FilterType.completed,
                      onChanged: null,
                    ),
                    Text("Completed"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: FilterType.pending,
                child: Row(
                  children: [
                    Checkbox(
                      value: _selectedFilter == FilterType.pending,
                      onChanged: null,
                    ),
                    Text("Pending"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: BlocConsumer<TaskBloc, TaskState>(
          listener: (context, state) {
            if(state is TaskDeletedState){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task Deleted !!')));
            }
            else if (state is ErrorTaskState){
             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message.toString()))); 
            }
          },
          builder: (context, state) {
            if (state is LoadingTaskState){
              return CircularProgressIndicator();
            }
            else if (state is EmptyTaskState){
              return Icon(Icons.hourglass_empty);
            }
            else if(state is ErrorTaskState){
              return Icon(Icons.error);
            }
            else if (state is TaskDeletedState) {
              return const SizedBox.shrink();
            }
            else if (state is LoadedTaskState){
              return ListView.builder(
                itemBuilder: (context,index){
                  bool isCompleted = state.tasksList[index].isCompleted;
                  return Slidable(
                    key: ValueKey(state.tasksList[index].id),
                    endActionPane: ActionPane(
                      motion: BehindMotion(), 
                      dismissible: DismissiblePane(
                        closeOnCancel: true,
                        confirmDismiss: () async => true,
                        dismissThreshold: 0.3,
                        onDismissed: () {
                          context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: state.tasksList[index]));
                        },
                      ),
                      children: [
                        SlidableAction(
                          backgroundColor: Colors.red,
                          onPressed: (context){
                            context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: state.tasksList[index]));
                          },
                          icon: Icons.delete,
                          label: "Delete",
                        )
                      ]
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/task_screen",arguments: state.tasksList[index],);
                      },
                      child: ListTile(
                        title: Text(state.tasksList[index].title),
                        subtitle: Text(state.tasksList[index].priority.name),
                        trailing: Checkbox(
                          value: isCompleted,
                          onChanged: (value){
                            context.read<TaskBloc>().add(EditTaskEvent(id: state.tasksList[index].id, title: state.tasksList[index].title, priority: state.tasksList[index].priority, description: state.tasksList[index].description, dueDate: state.tasksList[index].dueDate, isCompleted: value!));
                            _selectedFilter=FilterType.all;
                          }
                        ),
                      ),
                    ),
                  );
                },
                itemCount: state.tasksList.length,
                );
            }
            return Text("Faced Some Unexpected Issues.....");
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
