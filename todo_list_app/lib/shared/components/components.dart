import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../Layout/TodoBloc/TodoCubit.dart';
import 'constants.dart';

Widget buildLoginBtn({
  String text = 'Login',
  double width = double.infinity,
  required Null Function() function,
}) {
  return MaterialButton(
    child: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    onPressed: function,
    color: Colors.blue,
    minWidth: width,
    textColor: Colors.white,
    padding: EdgeInsets.all(10),
  );
}

//////////////////////////////////////////////////
Widget buildTextFormField({
  required TextEditingController controller,
  required String label,
  required IconData prefix,
  required TextInputType inputType,
  FormFieldValidator<String>? validatorFun,
  Null Function()? suffixFun,
  Null Function()? onTapFun,
  Null Function(String)? onChangedFun,
  Null Function(String)? onSubmittedFun,
  IconData? suffix,
  bool obscureText = false,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(prefix),
      suffixIcon: IconButton(
        icon: Icon(suffix),
        onPressed: suffixFun,
      ),
      border: OutlineInputBorder(),
    ),
    keyboardType: inputType,
    validator: validatorFun,
    obscureText: obscureText,
    onTap: onTapFun,
    onChanged: onChangedFun,
    onFieldSubmitted: onSubmittedFun,
    style: TextStyle(fontFamily: 'Arial'),
  );
}

//////////////////////////////////////////////////
Widget buildTaskItemOfList(Map map, context) {
  return Dismissible(
    key: Key(map['ID'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${map['TIME']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${map['TITLE']}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '${map['DATE']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              TodoCubit.getInstance(context).updateDatabase('done', map['ID']);
            },
            icon: Icon(Icons.check_box),
            color: Colors.green,
          ),
          SizedBox(
            width: 5,
          ),
          IconButton(
            onPressed: () {
              TodoCubit.getInstance(context)
                  .updateDatabase('archived', map['ID']);
            },
            icon: Icon(Icons.archive_outlined),
            color: Colors.black26,
          ),
        ],
      ),
    ),
    direction: DismissDirection.horizontal,
    onDismissed: (direction) {
      TodoCubit.getInstance(context).deleteDatabase(map['ID']);
    },
  );
}

Widget buildListSeparator() => Container(
      width: double.infinity,
      height: 1,
      color: Colors.grey[300],
    );

void navigateNextScreen(context, nextScreen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen));
}

void navigateNextScreenAndFinish(context, nextScreen) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => nextScreen), (route) => false);
}

void showToast(String msg, Color backgroundColor,
    {Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
    int timeInSecForIosWeb = 2,
    Color textColor = Colors.white,
    double fontSize = 15}) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize);
}

Future<void> showMyDialog(context, Null Function() yesFunction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout Alert'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                'Are you sure to logout ?',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: yesFunction,
          ),
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
