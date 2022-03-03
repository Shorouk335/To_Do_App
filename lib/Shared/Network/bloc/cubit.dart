import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/Layout/Archived.dart';
import 'package:to_do_app/Layout/Done.dart';
import 'package:to_do_app/Layout/Tasks.dart';
import 'package:to_do_app/Shared/Network/bloc/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitalState());

  // to make object from AppCubit use it in any place
  static AppCubit get(context) => BlocProvider.of(context);

  //bottomnav current index
  var currentIndex = 0;

  //appbartitle
  List<String> appBarTitle = ["NewTasks", "Done", "Archived"];
  //body screen
  List<Widget> Screens = [
    Tasks(),
    Done(),
    Archived(),
  ];

  //BottomSheet
  bool isBottomSheetShow = false;

  //Icon FloatingAction
  IconData sheetIcon = Icons.edit;

  //database object
  Database? database2;

  //List of tasks

  List<Map> newtasks = [];
  List<Map> Donetasks = [];
  List<Map> Archivedtasks = [];

  //change current index
  void onClic(index) {
    currentIndex = index;
    emit(ChangeBottomNavIndex());
  }

  //Change bottomsheet and icon
  void closedSheet() {
    isBottomSheetShow = false;
    sheetIcon = Icons.edit;
    emit(ClosedSheetState());
  }

  void openSheet() {
    isBottomSheetShow = true;
    sheetIcon = Icons.add;
    emit(OpenSheetState());
  }

//create database and table
  void createDataBase() async {
    await openDatabase('todoapp2.dp', version: 1,
        onCreate: (database2, vesion) async {
      await database2
          .execute(
              'CREATE TABLE tasks2 (id INTEGER PRIMARY KEY ,title TEXT , date TEXT , time TEXT ,status TEXT)')
          .then((value) {})
          .catchError((onError) {});
    }, onOpen: (database2) {
      getDataFromDataBase(database2);
    }).then((value) {
      database2 = value;
      emit(CreateDataBaseState());
    });
  }

//insert from database
  Future insertIntoDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database2?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks2 (title, date, time ,status ) VALUES("$title" ,"$date", "$time" , "now")')
          .then((value) {
        emit(InsertDataBaseState());
        getDataFromDataBase(database2);
      }).catchError((onError) {});
    });
  }

//get from data base
  void getDataFromDataBase(database2) {
    database2?.rawQuery('SELECT * FROM tasks2').then((value) {
      newtasks = [];
      Donetasks = [];
      Archivedtasks = [];
      value.forEach((element) {
        if (element["status"] == "Done") {
          Donetasks.add(element);
        } else if (element["status"] == "Archived") {
          Archivedtasks.add(element);
        } else {
          newtasks.add(element);
        }
      });
      emit(GetFromDataBaseState());
    });
  }

  //UpDate in DataBase

  void UpDateDataBase({required String status, required int id}) {
    database2?.rawUpdate('UPDATE tasks2 SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      emit(UpDateDataBaseState());
    }).then((value) {
      getDataFromDataBase(database2);
    });
  }

  void DeleteFromDataBase({required int id}) async{
   await database2?.rawDelete("DELETE FROM tasks2 WHERE id = ?", [id]).then((value) {
      getDataFromDataBase(database2);
      emit(GetFromDataBaseState());
      emit(DeleteFomDataBaseState());
    });
  }
}
