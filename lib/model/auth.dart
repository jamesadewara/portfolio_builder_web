import 'package:hive/hive.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:portfolio_builder_app/view/api/auth_api.dart';

class Auth extends NotifyListener {
  AuthApi auth_api = AuthApi();
  Box<AuthModel> collection = Hive.box<AuthModel>('authdb');

  signupUser(String username, String email, String password) {
    try {
      loginUser(email, password);
    } catch (e) {
      return null;
    }
  }

  Future<void> loginUser(String email, String password) async {
    var authModel = AuthModel(userId: "1", userName: "");

    try {
      collection.put(0, authModel); //user id// user name
      onChange();
    } catch (e) {
      return;
    }
    notifyListeners();
  }

  Future<void> logoutUser() async {
    try {
      auth_api.logOut(getAuth().userId);
      collection.clear();
    } catch (e) {
      return;
    }
    notifyListeners();
  }

  bool isLogged() {
    try {
      AuthModel authId = collection.get(0)!;
      return authId.userId.toString().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  AuthModel getAuth() {
    return collection.getAt(0)!;
  }
}
