import 'package:flutter/material.dart';
import '../network/local/MySharedPreferences.dart';
import '../network/remote/DioHelper.dart';


String NO_INTERNET_NOTIFICATION = 'No Internet Connection :(';
dynamic currentUserToken;
List<Map> newTasks = [];
List<Map> doneTasks = [];
List<Map> archivedTasks = [];
List<List<Map>> allTasksTypeList = [
  newTasks,
  doneTasks,
  archivedTasks,
];
bool isTasksEmpty = false;
List<dynamic> businessNews = [];
List<dynamic> sportsNews = [];
List<dynamic> sciencesNews = [];
List<dynamic> allFilteredNews = [];
String onBoardingKey = 'is BoardingScreen Skip';
String loginTokenKey = 'User Login Token';
const String homeLabel = 'Home';
const String categoriesLabel = 'Categories';
const String favLabel = 'Favourite';
const String settingsLabel = 'Settings';
const IconData homeIcon = Icons.home;
const IconData categoriesIcon = Icons.apps;
const IconData favIcon = Icons.favorite;
const IconData settingsIcon = Icons.settings;
Future<void> preInitRunApp() async {
  await MySharedPreferences.init();
  DioHelper.initShopApp(
      'en', currentUserToken = MySharedPreferences.retreiveData(loginTokenKey));
}
