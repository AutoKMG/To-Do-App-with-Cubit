import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/logic/handler.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  @required Function function,
  @required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );

Widget defaultFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool showCursor = true,
  bool readOnly = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      showCursor: showCursor,
      readOnly: readOnly,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );
Widget buildTaskItem(Map model, context) {
  AppHandler appHandler = BlocProvider.of<AppHandler>(context);
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          child: Text('${model['time']}'),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${model['date']}',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        IconButton(
            onPressed: model['status'] != 'done'
                ? () {
                    appHandler.updatingDatabase('done', model['id']);
                  }
                : () {
                    appHandler.updatingDatabase('new', model['id']);
                  },
            icon: model['status'] != 'done'
                ? Icon(Icons.check_circle_outline_outlined)
                : Icon(Icons.restart_alt_rounded),
            color: Colors.green),
        IconButton(
          onPressed: () {
            appHandler.updatingDatabase('archived', model['id']);
          },
          icon: Icon(
            Icons.archive,
            color: model['status'] != 'archived' ? Colors.blue : Colors.grey,
          ),
        ),
        IconButton(
            onPressed: () {
              appHandler.deletingFromDatabase(model['id']);
            },
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            )),
      ],
    ),
  );
}

Widget tasksBuilder(List tasks) {
  return ConditionalBuilder(
    condition: tasks.length > 0,
    builder: (context) {
      return ListView.separated(
          itemBuilder: (context, index) {
            return buildTaskItem(tasks[index], context);
          },
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 20),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),
            );
          },
          itemCount: tasks.length);
    },
    fallback: (context) {
      return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'OOPS!',
              style: TextStyle(
                  fontSize: 60,
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'There are no tasks here.',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    },
  );
}
