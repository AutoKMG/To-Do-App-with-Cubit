// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/logic/handler.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppHandler()..createDatabase(),
      child: BlocConsumer<AppHandler, AppState>(
        listener: (context, state) {
          if (state is AppStateInsertToDatabase) {
            Navigator.pop(context);
            titleController.clear();
            timeController.clear();
            dateController.clear();
          }
        },
        builder: (context, state) {
          AppHandler appHandler = BlocProvider.of<AppHandler>(context);
          return Scaffold(
            key: scaffoldKey,
            appBar:
                AppBar(title: Text(appHandler.titles[appHandler.currentIndex])),
            floatingActionButton: FloatingActionButton(
              onPressed: (() {
                if (appHandler.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    appHandler.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) {
                        return Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //
                                // title part
                                //
                                defaultFormField(
                                    controller: titleController,
                                    type: TextInputType.text,
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Title',
                                    prefix: Icons.title),
                                SizedBox(
                                  height: 15,
                                ),
                                //
                                // time part
                                //
                                defaultFormField(
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    readOnly: true,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value.format(context).toString();
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined),
                                SizedBox(
                                  height: 15,
                                ),
                                //
                                // date part
                                //
                                defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    readOnly: true,
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2023-12-31'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value);
                                      });
                                    },
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      return null;
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today),
                              ],
                            ),
                          ),
                        );
                      }, elevation: 20.0)
                      .closed
                      .then((value) {
                        appHandler.toggleButtomSheet(false);
                      });
                  appHandler.toggleButtomSheet(true);
                }
              }),
              child: appHandler.isBottomSheetShown
                  ? Icon(Icons.add)
                  : Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: appHandler.currentIndex,
              onTap: (index) {
                appHandler.changeCurrentIndex(index);
                // setState(() {
                //   currentIndex = index;
                // });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived')
              ],
            ),
            body: ConditionalBuilder(
              condition: state is! AppStateLoadingDatabase,
              builder: (context) {
                return appHandler.screens[appHandler.currentIndex];
              },
              fallback: (context) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
