import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';

part 'state.dart';

class AppHandler extends Cubit<AppState> {
  AppHandler() : super(AppStateInitial());
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  Database database;
  bool isBottomSheetShown = false;
  List<Task> newTasks = [];
  List<Task> doneTasks = [];
  List<Task> archivedTasks = [];
  void changeCurrentIndex(int index) {
    currentIndex = index;
    emit(AppStateChangeCurrentIndex());
  }

  void toggleButtomSheet(bool isShow) {
    isBottomSheetShown = isShow;
    emit(AppStateTogglingBottomSheet());
  }

  void createDatabase() {
    emit(AppStateLoadingDatabase());
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db, version) {
        print('database created');
        db
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('Error when creating table: ${error.toString()}');
        });
      },
      onOpen: (db) {
        getDataFromDatabase(db);
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppStateCreateDatabase());
    });
  }

  void insertToDatabase(
      {@required String title, @required String time, @required String date}) {
    database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("$title","$date","$time","new")')
          .then((value) {
        emit(AppStateInsertToDatabase());
        getDataFromDatabase(database);
        print("$value Row Inserted Successfully");
      }).catchError((error) {
        print("Error occurred while inserting a new row: ${error.toString()}");
      });
      return null;
    });
  }

  void deletingFromDatabase(id) {
    database.rawDelete('DELETE FROM tasks WHERE id = $id').then((value) {
      print('$id raw deleted');
      emit(AppStateDeletingFromDatabase());
      getDataFromDatabase(database);
    }).catchError((error) {
      print("Error happened while deleting a row: ${error.toString()}");
    });
  }

  void updatingDatabase(String status, id) {
    database
        .rawUpdate("UPDATE tasks SET status = '$status' WHERE id = $id")
        .then((value) {
      emit(AppStateUpdateDatabase());
      getDataFromDatabase(database);
    }).catchError((error) {
      print("Error happened while updating database: ${error.toString()}");
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        if (!value.isEmpty) {
          print(value);
          value
              .where((item) => item['status'] == 'new')
              .toList()
              .forEach((element) {
            newTasks.add(Task.fromJson(element));
          });
          print(newTasks);
          value
              .where((item) => item['status'] == 'done')
              .toList()
              .forEach((element) {
            doneTasks.add(Task.fromJson(element));
          });
          print(doneTasks);
          value
              .where((item) => item['status'] == 'archived')
              .toList()
              .forEach((element) {
            archivedTasks.add(Task.fromJson(element));
          });
          print(archivedTasks);
        } else {
          newTasks = [];
          doneTasks = [];
          archivedTasks = [];
        }
        emit(AppStateGetFromDatabase());
      },
    );
    ;
  }
}
