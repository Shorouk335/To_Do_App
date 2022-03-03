import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/Shared/Components/TextFormWidget.dart';
import 'package:to_do_app/Shared/Components/Context.dart';
import 'package:to_do_app/Shared/Network/bloc/cubit.dart';
import 'package:to_do_app/Shared/Network/bloc/states.dart';
import 'package:intl/intl.dart';

class ToDo extends StatefulWidget {
  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit(),
      child: BlocConsumer< AppCubit,AppStates>(
        listener: (context , state){},
          builder: (context , state){
          AppCubit cubit = AppCubit.get(context)..createDataBase();
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                "${cubit.appBarTitle[cubit.currentIndex]}",
              ),
            ),
            body: cubit.Screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              //isBottomSheetShow = true is right now open and want to close it
              //isBottomSheetShow = false is right now close and want to open it
              onPressed: () {
                if (cubit.isBottomSheetShow)
                {
                  if (formKey.currentState!.validate()) {
                    cubit.insertIntoDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text ,
                    ).then((value) {
                      titleController.clear();
                      timeController.clear();
                      dateController.clear();
                          Navigator.pop(context);
                          cubit.closedSheet();
                    }).catchError((onError) {});
                  }
                }
                else
                  {
                cubit.openSheet();
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.2,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextFormWidget(
                            Label: "title",
                            prefIcon: Icons.title,
                            Controller: titleController,
                            type: TextInputType.emailAddress,
                          ),
                          TextFormWidget(
                              Label: "time",
                              prefIcon: Icons.watch_later_outlined,
                              Controller: timeController,
                              OnTap: () {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timeController.text =
                                      value!.format(context);
                                });
                              }),
                          TextFormWidget(
                              Label: "date",
                              prefIcon: Icons.calendar_today_outlined,
                              Controller: dateController,
                              OnTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.parse('2022-05-05'),
                                ).then((value) {
                                  dateController.text = DateFormat.yMMMd().format(value!);
                                });
                              }),
                        ],
                      ),
                    ),
                  ))
                      .closed
                      .then((value) {
                    cubit.closedSheet();
                    titleController.clear();
                    timeController.clear();
                    dateController.clear();
                  }).catchError((onError) {});
                }
              },
              child: Icon(cubit.sheetIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
               cubit.onClic(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), title: Text("Tasks")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), title: Text("Done")),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), title: Text("Archived")),
              ],
            ),
          );
          }

      ),
    );
  }
}
