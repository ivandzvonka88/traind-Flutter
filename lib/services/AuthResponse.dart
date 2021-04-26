import 'package:traind_flutter/models/User.dart';

class AuthResponse {
  bool success = false;
  User user = null;
  String error = 'Something went wrong! Please try again!';
}
