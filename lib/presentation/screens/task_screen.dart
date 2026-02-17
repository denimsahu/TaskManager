import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<TaskScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController dueDateTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController priorityTextEditingController = TextEditingController();
  PriorityEnum? selectedPriority;
  DateTime? _selectedDate;
  bool isCompleted = false;

  TaskEntity? taskEntity;

  @override
  void dispose() {
    titleTextEditingController.dispose();
    dueDateTextEditingController.dispose();
    descriptionTextEditingController.dispose();
    priorityTextEditingController.dispose();
    super.dispose();
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    if(!_isInitialized){
      if(ModalRoute.of(context)?.settings.arguments != null){
        taskEntity = ModalRoute.of(context)?.settings.arguments as TaskEntity;
        titleTextEditingController.value=TextEditingValue(text:taskEntity!.title);
        priorityTextEditingController.value=TextEditingValue(text: taskEntity!.priority.name);
        selectedPriority=taskEntity!.priority;
        isCompleted=taskEntity!.isCompleted;
        if(taskEntity!.description!=null){
          descriptionTextEditingController.value=TextEditingValue(text: taskEntity!.description!);
        }
        if(taskEntity!.dueDate != null){
          dueDateTextEditingController.value=TextEditingValue(text: "${taskEntity!.dueDate!.day}/${taskEntity!.dueDate!.month}/${taskEntity!.dueDate!.year}");
          _selectedDate = taskEntity!.dueDate;
        }
      }
      _isInitialized = true;
    }
    super.didChangeDependencies();
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }



    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3E7EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3E7EB),
        elevation: 0,
        title: Text(taskEntity != null ? "Edit Task" : "Add Task"),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildCard(
                        child: TextFormField(
                          controller: titleTextEditingController,
                          decoration: const InputDecoration(
                            labelText: "Title",
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            isDense: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter Title";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildCard(
                              child: TextFormField(
                                controller: dueDateTextEditingController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: "Due Date",
                                  suffixIcon: Icon(Icons.calendar_today),
                                  border: InputBorder.none,
                                  fillColor: Colors.transparent,
                                  isDense: true,
                                ),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(3000),
                                    initialDate:
                                        _selectedDate ?? DateTime.now(),
                                  );

                                  if (pickedDate != null) {
                                    setState(() {
                                      _selectedDate = pickedDate;
                                      dueDateTextEditingController.text =
                                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildCard(
                              child: DropdownMenuFormField(
                                inputDecorationTheme:
                                    const InputDecorationTheme(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                label: const Text("Priority"),
                                controller: priorityTextEditingController,
                                dropdownMenuEntries: [
                                  DropdownMenuEntry(value: PriorityEnum.low,label: PriorityEnum.low.name),
                                  DropdownMenuEntry(value: PriorityEnum.medium,label: PriorityEnum.medium.name),
                                  DropdownMenuEntry(value: PriorityEnum.high,label: PriorityEnum.high.name),
                                ],
                                onSelected: (value) {
                                  selectedPriority = value;
                                },
                                validator: (value) {
                                  if (value == null &&
                                      selectedPriority == null) {
                                    return "Select Priority";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: _buildCard(
                          child: TextFormField(
                            controller: descriptionTextEditingController,
                            decoration: const InputDecoration(
                              labelText: "Description",
                              border: InputBorder.none,
                              fillColor: Colors.transparent,
                              isDense: true,
                              alignLabelWithHint: true,
                            ),
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCard(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text("Mark as Completed"),
                          value: isCompleted,
                          onChanged: (value) {
                            setState(() {
                              isCompleted = value!;
                            });
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      BlocListener<TaskBloc, TaskState>(
                        listener: (context, state) {
                          if (state is TaskAddedState) {
                            Navigator.pop(context);
                            context.read<TaskBloc>().add(LoadAllTaskEvent());
                          }
                          else if (state is TaskUpdatedState) {
                            Navigator.pop(context);
                          }
                          else if (state is TaskDeletedState){
                              Navigator.of(context).pop();
                          }
                          else if (state is ErrorTaskState){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message.toString())));
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F3A45),
                                  foregroundColor: Colors.white,
                                  elevation: 6,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (taskEntity != null) {
                                        context.read<TaskBloc>().add(
                                          EditTaskEvent(
                                            id: taskEntity!.id,
                                            title: titleTextEditingController.text,
                                            priority: selectedPriority!,
                                            description: descriptionTextEditingController.text,
                                            dueDate: _selectedDate,
                                            isCompleted: isCompleted,
                                          ),
                                        );
                                    } else {
                                      context.read<TaskBloc>().add(
                                        AddTaskEvent(
                                          title: titleTextEditingController.text,
                                          priority: selectedPriority!,
                                          description: descriptionTextEditingController.text,
                                          dueDate: _selectedDate,
                                          isCompleted: isCompleted,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text("Save Task"),
                              ),
                            ),

                            if (taskEntity != null) ...[
                              const SizedBox(width: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7F8FA),
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<TaskBloc>().add(
                                      DeleteTaskEvent(taskEntity: taskEntity!),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),//

    );
  }
}
