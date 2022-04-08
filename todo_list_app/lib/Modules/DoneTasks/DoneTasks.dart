import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Layout/TodoBloc/TodoCubit.dart';
import '../../Layout/TodoBloc/TodoStates.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';
class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){},
      builder: (context,state)=>ListView.separated(
          itemBuilder: (context, index) => buildTaskItemOfList(doneTasks[index],context),
          separatorBuilder: (context,index)=> Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
          itemCount: doneTasks.length),
    );
  }
}
