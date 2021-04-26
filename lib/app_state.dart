import 'app_state_container.dart';

class AppState {
  bool isLoading;
  var user;
  AuthType type;
  String errorMessage;

  AppState({this.isLoading = false, this.user, this.type});

  factory AppState.loading() => new AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}
