import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../Modules/ArchivedTasks/ArchivedTasks.dart';
import '../../Modules/DoneTasks/DoneTasks.dart';
import '../../Modules/NewTasks/NewTasks.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
import 'TodoStates.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit getInstance(context) => BlocProvider.of(context);
  static var localDatabase;
  static int currentIndex = 0;
   IconData fabIcon=Icons.edit;
   bool isBottomSheetShown=false;
  static var scaffoldKey=GlobalKey<ScaffoldState>();
  static var formedKey=GlobalKey<FormState>();
  static var titleController=TextEditingController();
  static var timeController=TextEditingController();
  static var dateController=TextEditingController();
  List<Widget> bodyNavigationList=[
    const NewTasks(),
    const DoneTasks(),
    const ArchivedTasks()
  ];
  List<String> appBarNavigationList=[
    'NewTasks',
    'DoneTasks',
    'ArchivedTasks'
  ];
  void setBottomNavigationIndex(int index) {
    currentIndex = index;
    emit(TodoChangeBottomNavigationIndexState());
  }
  void controlBottomSheetFromFloatingActionBtn(BuildContext context){
    if(isBottomSheetShown){
      if(formedKey.currentState!.validate()){
        insertToDatabase(titleController.text, dateController.text, timeController.text);
      }
    }
    else{
      isBottomSheetShown=!isBottomSheetShown;
      fabIcon=Icons.add;
      scaffoldKey.currentState!.showBottomSheet(
            (context) =>
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formedKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildTextFormField(
                        controller: titleController,
                        label: 'Task Title',
                        prefix: Icons.title,
                        inputType: TextInputType.text,
                        validatorFun: (value){
                          if(value!.isEmpty){
                            return 'title must be fill!';
                          }
                          return null;
                        }
                    ),
                    SizedBox(height: 10,),
                    buildTextFormField(
                        controller: timeController,
                        label: 'Task Time',
                        prefix: Icons.watch_later_outlined,
                        inputType: TextInputType.datetime,
                        validatorFun: (value){
                          if(value!.isEmpty){
                            return 'time must be fill!';
                          }
                          return null;
                        },
                        onTapFun: (){
                          showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          ).then((value) {
                            timeController.text=value!.format(context);
                          }).catchError(
                                  (error){
                                print(error.toString());
                              }
                          );
                        }
                    ),
                    SizedBox(height: 10,),
                    buildTextFormField(
                      controller: dateController,
                      label: 'Task Date',
                      prefix: Icons.calendar_today,
                      inputType: TextInputType.datetime,
                      validatorFun: (value){
                        if(value!.isEmpty){
                          return 'date must be fill!';
                        }
                        return null;
                      },
                      onTapFun: (){
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse('2022-04-30')
                        ).then((value) {
                          dateController.text=DateFormat.yMMMd().format(value!);
                        }).catchError(
                                (error){
                              print(error.toString());
                            }
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        elevation: 20,
        backgroundColor: Colors.grey[300],
      ).closed.then((value) {
            isBottomSheetShown=!isBottomSheetShown;
            fabIcon=Icons.edit;
            emit(TodoCloseBottomSheetFromFloatingActionBtnState());
          }
      );
      emit(TodoShowBottomSheetFromFloatingActionBtnState());
    }
  }
  ////////////////////////////////////////////////////////////////////////helper methods
  void create_open_Database() {
    openDatabase(
        'Todo.db',
        version: 1,
        onCreate: (database,version){
          print('database created');
          database.execute('CREATE TABLE TASKS (ID INTEGER PRIMARY KEY,TITLE TEXT,DATE TEXT,TIME TEXT,STATUS TEXT)').then((value) {
            print('tasks table created');
          }
          ).catchError(
                  (error){
                print('Error when created tasks table is = ${error.toString()}');
              }
          );
        },
        onOpen: (database){
          print('database opened');
          getAllDataFromDatabase(database);
        }
    ).then((value) {
      localDatabase=value;
      emit(TodoCreateDatabaseState());
    });
  }
  insertToDatabase(String title,String date,String time){
    localDatabase.transaction((txn) {
      txn.rawInsert('INSERT INTO TASKS (TITLE,DATE,TIME,STATUS) VALUES("$title","$date","$time","new")').then((value) {
        emit(TodoProgressBarState());
        print('${value} is inserted successfully');
        emit(TodoInsertToDatabaseState());
        getAllDataFromDatabase(localDatabase);
      }).catchError(
              (Error){
            print('error in insertion = ${Error.toString()}');
          });
      return Future<void>((){});
    });
  }
  void getAllDataFromDatabase(Database database) {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    database.rawQuery('SELECT * FROM TASKS').then((value) {
      print(value);
      value.forEach((element) {
        if(element['STATUS'] == 'new')
          newTasks.add(element);
        else if(element['STATUS'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      if(newTasks.isEmpty || doneTasks.isEmpty || archivedTasks.isEmpty)
        emit(TodoNoTasksFoundState());
      else
        emit(TodoGetAllTasksFromDatabaseState());
    });
  }
  void updateDatabase(String status,int id){
    localDatabase.rawUpdate(
        'UPDATE TASKS SET STATUS = ? WHERE ID = ?',
        [status,id]).then((value) {
          emit(TodoProgressBarState());
          getAllDataFromDatabase(localDatabase);
          emit(TodoUpdateDatabaseState());
    });
  }
  void deleteDatabase(int id){
    localDatabase.rawDelete(
        'DELETE FROM TASKS WHERE ID = ?',
        [id]).then((value) {
          emit(TodoDeleteDatabaseState());
          getAllDataFromDatabase(localDatabase);
    });
  }
//////////////////////////////////////////////////////////////////////////////////////
}
