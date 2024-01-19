import 'package:hive/hive.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';

class Auth {
  Box<AuthModel> collection = Hive.box<AuthModel>('authdb');

  signupUser(String username, String email, String password) {
    try {
      loginUser(email, password);
    } catch (e) {
      return null;
    }
  }

  loginUser(String email, String password) {
    var authModel = AuthModel(userId: "1", userName: "");

    try {
      collection.put(0, authModel); //user id// user name
    } catch (e) {
      return null;
    }
  }

  logoutUser() {
    try {
      collection.clear();
    } catch (e) {
      return null;
    }
  }

  bool isLogged() {
    try {
      AuthModel authId = collection.get(0)!;
      return authId.userId.toString().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  AuthModel auth() {
    return collection.get(0)!;
  }
}
