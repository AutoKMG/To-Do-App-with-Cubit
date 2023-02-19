part of 'handler.dart';

@immutable
abstract class AppState {}

class AppStateInitial extends AppState {}

class AppStateChangeCurrentIndex extends AppState {}

class AppStateTogglingBottomSheet extends AppState {}

class AppStateLoadingDatabase extends AppState {}

class AppStateCreateDatabase extends AppState {}

class AppStateGetFromDatabase extends AppState {}

class AppStateInsertToDatabase extends AppState {}

class AppStateUpdateDatabase extends AppState {}

class AppStateDeletingFromDatabase extends AppState {}
