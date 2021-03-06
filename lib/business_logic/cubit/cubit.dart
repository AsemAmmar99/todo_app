import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/business_logic/cubit/states.dart';

import '../../presentation/screens/archived_tasks/archived_tasks_screen.dart';
import '../../presentation/screens/done_tasks/done_tasks_screen.dart';
import '../../presentation/screens/new_tasks/new_tasks_screen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitState());

  static AppCubit get(context) => BlocProvider.of<AppCubit>(context);

  int currentIndex = 0;

  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];

  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index){
    currentIndex = index;
    emit(AppChangeBNBState());
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  late Database database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version){
        if (kDebugMode) {
          print('database created');
        }
        database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)').then((value){
          if (kDebugMode) {
            print('table created');
          }
        }).catchError((error){
          if (kDebugMode) {
            print('Error when creating table ${error.toString()}');
          }
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        if (kDebugMode) {
          print('database opened');
        }
      },
    ).then((value){
      database = value;
      emit(AppCreateDBState());
    });
  }

  insertToDatabase({required String title, required String time, required String date,}) async{
    await database.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")'
      ).then((value) {
        if (kDebugMode) {
          print('task $value successfully inserted!');
        }
        emit(AppInsertDBState());

        getDataFromDatabase(database);
      }
      ).catchError((error){
        if (kDebugMode) {
          print('Error when inserting to database ${error.toString()}');
        }
      });
    });
  }

  void getDataFromDatabase(database) {

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDBLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        } else if(element['status'] == 'done'){
          doneTasks.add(element);
        } else{
          archivedTasks.add(element);
        }
      });
      
      emit(AppGetDBState());
    });
  }

  void updateData({
  required String status,
  required int id,
  }) async{
     database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDBState());
     });
  }

  void deleteData({
    required int id,
  }) async{
    database.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDBState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  void changeBSState({
  required bool isShow,
  required IconData icon,
  }){
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBSState());
  }
}