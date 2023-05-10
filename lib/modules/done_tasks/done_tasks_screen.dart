import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/logic/handler.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppHandler, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List<Task> tasks = BlocProvider.of<AppHandler>(context).doneTasks;
        return tasksBuilder(tasks);
      },
    );
  }
}
