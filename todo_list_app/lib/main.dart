import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/Layout/TodoBloc/TodoStates.dart';
import 'package:todo_list_app/Layout/TodoLayout.dart';
import 'package:todo_list_app/shared/BlocObserverTest.dart';
import 'package:todo_list_app/shared/components/constants.dart';
import 'package:todo_list_app/shared/styles/styles.dart';

import 'Layout/TodoBloc/TodoCubit.dart';

void main() {
  BlocOverrides.runZoned(
        () async {
      WidgetsFlutterBinding
          .ensureInitialized(); //بتضمن ان الكود اللى بعدها يتنفذ اولا قبل تشغيل التطبيق
      await preInitRunApp(); //تستخدم لتعريف المكونات المهمة التى سوف تستخدم على مستوى التطبيق ككل مثل الsharedPref,dioApi
      runApp(MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit()..create_open_Database(),
      child: BlocConsumer<TodoCubit, TodoStates>(
          listener: (context, state) {},
          builder: (context, state) {
        return MaterialApp(
          home: TodoLayout(),
          debugShowCheckedModeBanner: false,
          theme: appLightTheme,
        );
      }),
    ); //الماتريال اب هى اللى شايله كل سكرينات التطبيق بمعنى اصح هى تعتبر الاكتيفتيز ستاك وايضا من خلال نقدر نضع اعدادات وستايل للتطبيق كله
  }
}
