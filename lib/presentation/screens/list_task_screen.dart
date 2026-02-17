import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/task_card.dart';

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
      backgroundColor: const Color(0xFFE3E7EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E7EB),
        title: SizedBox(
          height: MediaQuery.of(context).size.height*0.06,
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              return SearchAnchor(
                suggestionsBuilder: (context, controller) {
                  if (state is LoadedTaskState) {
                    final query = controller.text.toLowerCase();
                    if (query.isEmpty) return const <Widget>[];
                    final suggestions = state.tasksList.where((task) =>task.title.toLowerCase().contains(query)).toList();
                    return suggestions.map((task) {
                      return BlocBuilder<TaskBloc, TaskState>(
                        builder: (context, state) {
                          if (state is LoadedTaskState) {
                            final updatedTask = state.tasksList
                                .firstWhere((t) => t.id == task.id);
                            return TaskCard(
                              task: updatedTask,
                              onTap: () {
                                controller.closeView(null);
                                controller.clear();
                                Navigator.pushNamed(context,"/task_screen",arguments: updatedTask);
                              },
                              onToggle: (value) {
                                context.read<TaskBloc>().add(
                                      EditTaskEvent(
                                        id: updatedTask.id,
                                        title: updatedTask.title,
                                        priority: updatedTask.priority,
                                        description: updatedTask.description,
                                        dueDate: updatedTask.dueDate,
                                        isCompleted: value!,
                                      ),
                                    );
                              },
                              onDelete: () {context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: updatedTask),);},
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      );
                    }).toList();
                  }
                  return const <Widget>[];
                },
                builder: (context, controller) {
                  return SearchBar(
                    readOnly: true,
                    hintText: 'Search tasks...',
                    elevation: const WidgetStatePropertyAll(2),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    leading: const Icon(Icons.search),
                    onTap: () => controller.openView(),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          PopupMenuButton<FilterType>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
              context
                  .read<TaskBloc>()
                  .add(FilterTaskEvent(filterType: value));
            },
            itemBuilder: (context) => [
              _buildFilterItem(FilterType.all, "All"),
              _buildFilterItem(FilterType.completed, "Completed"),
              _buildFilterItem(FilterType.pending, "Pending"),
            ],
          ),
        ],
      ),
      body: BlocConsumer<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskDeletedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task Deleted !!')),
            );
          } 
          else if (state is ErrorTaskState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message.toString())));
          }
        },
        builder: (context, state) {
          if (state is LoadingTaskState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is EmptyTaskState) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt,
                      size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No tasks yet",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap + to create your first task",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          if (state is ErrorTaskState) {
            return const Center(
              child: Icon(Icons.error, size: 60),
            );
          }

          if (state is LoadedTaskState) {
            final tasks = state.tasksList;

            return SlidableAutoCloseBehavior(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: ListView.builder(
                  key: ValueKey(tasks.length),
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 100),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Slidable(
                      key: ValueKey(task.id),
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        dismissible: DismissiblePane(
                          closeOnCancel: true,
                          confirmDismiss: () async => true,
                          dismissThreshold: 0.3,
                          onDismissed: () {context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: task));},
                        ),
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.red,
                            onPressed: (_) {context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: task));},
                            icon: Icons.delete,
                            label: "Delete",
                          ),
                        ],
                      ),
                      child: TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/task_screen",
                            arguments: task,
                          );
                        },
                        onToggle: (value) {
                          context.read<TaskBloc>().add(
                                EditTaskEvent(
                                  id: task.id,
                                  title: task.title,
                                  priority: task.priority,
                                  description:task.description,
                                  dueDate: task.dueDate,
                                  isCompleted: value!,
                                ),
                              );
                          _selectedFilter = FilterType.all;
                        },
                        onDelete: () {context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: task));},
                      ),
                    );
                  },
                ),
              ),
            );
          }

          return const Center(
            child: Text(
              "Faced Some Unexpected Issues.....",
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4,
        backgroundColor: const Color(0xFF2F3A45),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed("/task_screen");
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
      ),
    );
  }

  PopupMenuItem<FilterType> _buildFilterItem(
      FilterType type, String label) {
    return PopupMenuItem(
      value: type,
      child: Row(
        children: [
          Checkbox(
            value: _selectedFilter == type,
            onChanged: null,
          ),
          Text(label),
        ],
      ),
    );
  }
}
