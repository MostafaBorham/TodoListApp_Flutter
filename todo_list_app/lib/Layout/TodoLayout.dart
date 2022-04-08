import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/components/constants.dart';
import 'TodoBloc/TodoCubit.dart';
import 'TodoBloc/TodoStates.dart';

class TodoLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {
        allTasksTypeList = [
          newTasks,
          doneTasks,
          archivedTasks,
        ];
        if (state is TodoInsertToDatabaseState) {
          Navigator.pop(context);
        }
        if (state is TodoProgressBarState) {
          isTasksEmpty = false;
        } else if (state is TodoNoTasksFoundState) {
          isTasksEmpty = true;
        }
      },
      builder: (context, state) => Scaffold(
          key: TodoCubit.scaffoldKey,
          appBar: AppBar(
            leading: Icon(
              Icons.menu,
            ),
            title: Text(
              TodoCubit.getInstance(context)
                  .appBarNavigationList[TodoCubit.currentIndex],
            ),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: IconButton(
              icon: Icon(
                TodoCubit.getInstance(context).fabIcon,
              ),
              onPressed: () {
                TodoCubit.getInstance(context)
                    .controlBottomSheetFromFloatingActionBtn(context);
              },
            ),
            onPressed: () {
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.menu,
                ),
                label: 'New Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.check_box,
                ),
                label: 'Done Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.archive_outlined,
                ),
                label: 'Archived Tasks',
              ),
            ],
            currentIndex: TodoCubit.currentIndex,
            onTap: (index) {
              TodoCubit.getInstance(context).setBottomNavigationIndex(index);
            },
          ),
          body: ConditionalBuilder(
              condition: allTasksTypeList[TodoCubit.currentIndex].length > 0,
              builder: (context) => TodoCubit.getInstance(context)
                  .bodyNavigationList[TodoCubit.currentIndex],
              fallback: (context) => Center(
                    child: isTasksEmpty
                        ? Text(
                            'No Tasks Found!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          )
                        : CircularProgressIndicator(),
                  ))),
    );
  }
}
