import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/presentation/bloc/task_bloc.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  GlobalKey<FormState> _formstate = GlobalKey<FormState>();
  TextEditingController titleTextEditingController = TextEditingController();
  TextEditingController prorityTextEditingController = TextEditingController();
  TextEditingController dueDateTextEditingController = TextEditingController();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  DateTime? _selectedDate;
  bool isCompleted = false;

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
              key: _formstate,
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
                                dueDateTextEditingController.text =
                                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              });
                            }
                          },
                        ),
                      ),
                      DropdownMenuFormField(
                        label: Text("Prority"),
                        controller: prorityTextEditingController,
                        dropdownMenuEntries: [
                          DropdownMenuEntry(value: "0", label: "Low"),
                          DropdownMenuEntry(value: "1", label: "Medium"),
                          DropdownMenuEntry(value: "2", label: "High"),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select Prority";
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
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formstate.currentState!.validate()) {
                          print(
                            titleTextEditingController.text +
                                " " +
                                dueDateTextEditingController.text +
                                " " +
                                prorityTextEditingController.text +
                                " " +
                                isCompleted.toString(),
                          );
                          context.read<TaskBloc>().add(
                            AddTaskEvent(
                              title: titleTextEditingController.text,
                              priority: prorityTextEditingController.text,
                              description:
                                  descriptionTextEditingController.text,
                              dueDate: _selectedDate,
                              isCompleted: isCompleted,
                            ),
                          );
                        }
                      },
                      child: Text("Add Task"),
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
