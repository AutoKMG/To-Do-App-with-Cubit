import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/logic/handler.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppHandler, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        List tasks = BlocProvider.of<AppHandler>(context).newTasks;
        return tasksBuilder(tasks);
      },
    );
  }
}
