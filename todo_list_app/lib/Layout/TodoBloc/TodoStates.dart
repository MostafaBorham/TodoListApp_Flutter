abstract class TodoStates{}

class TodoInitialState extends TodoStates{}
class TodoChangeBottomNavigationIndexState extends TodoStates{}
class TodoShowBottomSheetFromFloatingActionBtnState extends TodoStates{}
class TodoCloseBottomSheetFromFloatingActionBtnState extends TodoStates{}
class TodoGetAllTasksFromDatabaseState extends TodoStates{}
class TodoCreateDatabaseState extends TodoStates{}
class TodoInsertToDatabaseState extends TodoStates{}
class TodoUpdateDatabaseState extends TodoStates{}
class TodoDeleteDatabaseState extends TodoStates{}
class TodoNoTasksFoundState extends TodoStates{}
class TodoProgressBarState extends TodoStates{}