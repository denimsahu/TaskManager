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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(label: Text("Title")),
                    controller: titleTextEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Title";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        child: TextFormField(
                          controller: dueDateTextEditingController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Due Date",
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(3000),
                              initialDate: _selectedDate ?? DateTime.now(),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                _selectedDate = pickedDate;
                                dueDateTextEditingController.text ="${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              });
                            }
                          },
                        ),
                      ),
                      DropdownMenuFormField(
                        label: Text("Priority"),
                        controller: priorityTextEditingController,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: PriorityEnum.low, label: PriorityEnum.low.name),
                          DropdownMenuEntry(value: PriorityEnum.medium, label: PriorityEnum.medium.name),
                          DropdownMenuEntry(value: PriorityEnum.high, label: PriorityEnum.high.name),
                        ],
                        onSelected: (value) {
                          selectedPriority = value;
                        },
                        validator: (value) {
                          if (value == null && selectedPriority==null) {
                            return "Select Priority";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: descriptionTextEditingController,
                    decoration: InputDecoration(label: Text("Description")),
                    maxLines: 10,
                  ),
                  Container(
                    width: 200,
                    child: CheckboxListTile(
                      checkboxScaleFactor: 1.5,
                      title: Text("Completed"),
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                        });
                      },
                    ),
                  ),
                  BlocListener<TaskBloc, TaskState>(
                    listener: (context, state) {
                      if(state is TaskAddedState){
                        Navigator.pop(context);
                        context.read<TaskBloc>().add(LoadAllTaskEvent());
                      }
                      if(state is TaskUpdatedState){
                        
                        Navigator.pop(context);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if(taskEntity!=null){
                                try{
                                  // print(selectedPriority.toString());
                                  context.read<TaskBloc>().add(EditTaskEvent(id: taskEntity!.id, title: titleTextEditingController.text, priority: selectedPriority!, description: descriptionTextEditingController.text, dueDate: _selectedDate, isCompleted: isCompleted));
                                }
                                catch(error){
                                  print(error.toString());
                                }
                              }
                              else{
                                context.read<TaskBloc>().add(
                                  AddTaskEvent(
                                    title: titleTextEditingController.text,
                                    priority: selectedPriority!,
                                    description:descriptionTextEditingController.text,
                                    dueDate: _selectedDate,
                                    isCompleted: isCompleted,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text("Save Task"),
                        ),
                        BlocListener<TaskBloc, TaskState>(
                          listener: (context, state) {
                            if(state is TaskDeletedState){
                              Navigator.of(context).pop();
                              context.read<TaskBloc>().add(LoadAllTaskEvent());
                            }
                          },
                          child: taskEntity!=null?
                          IconButton(
                              onPressed: (){
                                context.read<TaskBloc>().add(DeleteTaskEvent(taskEntity: taskEntity!));
                              }, 
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                            ):SizedBox()
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
