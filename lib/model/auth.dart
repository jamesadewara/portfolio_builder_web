// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:portfolio_builder_app/control/conversions.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/view/api/api_prop.dart';
import 'package:portfolio_builder_app/view/api/auth_api.dart';

class Auth extends NotifyListener {
  AuthApi authApi = AuthApi();
  Box<AuthModel> collection = Hive.box<AuthModel>('authdb');

  Future<void> updateUser(BuildContext context,
      {required String username}) async {
    AuthModel? userInfo = collection.get(0);

    if (userInfo != null) {
      Map<String, dynamic> updateData = {"username": username};

      try {
        ApiRequest request =
            await authApi.updateUser(userInfo.token, updateData);

        if (request.error) {
          genericErrorMessage(context, title: "Error", message: request.data);
        } else {
          genericErrorMessage(context,
              title: "Success", message: "Successfully updated your account");
        }
      } catch (e) {
        handleException(context, e);
      }
    } else {
      // print("Error: AuthModel is null");
    }
  }

  Future<void> signupUser(BuildContext context,
      {required String username,
      required String email,
      required String password}) async {
    Map<String, dynamic> signupData = {
      "username": username,
      "email": email,
      "password": password
    };

    try {
      ApiRequest request = await authApi.signup(signupData);

      if (request.error) {
        genericErrorMessage(context, title: "Error", message: request.data);
      } else {
        await signinUser(context, email: email, password: password);
      }
    } catch (e) {
      handleException(context, e);
    }
  }

  Future<void> signinUser(BuildContext context,
      {required String email, required String password}) async {
    try {
      ApiRequest request =
          await authApi.signin({"email": email, "password": password});

      if (request.error) {
        genericErrorMessage(context, title: "Error", message: request.data);
      } else {
        String jsonString = request.data;

        var jsonData = stringToJson(jsonString);
        // Access the value of "access"
        String accessValue = jsonData['access'];

        var authModel = AuthModel(token: accessValue);
        collection.put(0, authModel);
        onChange();
        getAuth();
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    } catch (e) {
      handleException(context, e);
    }
  }

  Future<void> deleteUser(BuildContext context) async {
    AuthModel? userInfo = collection.get(0);

    try {
      if (userInfo != null) {
        ApiRequest request =
            await authApi.deleteUser(userInfo.token, userInfo.uid);

        if (request.error) {
          genericErrorMessage(context, title: "Error", message: request.data);
        } else {
          await collection.clear();
          await Navigator.pushReplacementNamed(context, AppRoutes.login);
          notifyListeners();
        }
      } else {
        // print("Error: AuthModel is null");
      }
    } catch (e) {
      handleException(context, e);
    }
    await collection.clear();
    await Navigator.pushReplacementNamed(context, AppRoutes.login);
    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    AuthModel? userInfo = collection.get(0);

    try {
      if (userInfo != null) {
        ApiRequest request = await authApi.signout(userInfo.token);

        if (request.error) {
          genericErrorMessage(context, title: "Error", message: request.data);
        }
      } else {
        // print("Error: AuthModel is null");
      }
    } catch (e) {
      handleException(context, e);
    }
    await collection.clear();
    await Navigator.pushReplacementNamed(context, AppRoutes.login);

    notifyListeners();
  }

  bool isLogged() {
    try {
      AuthModel? authId = collection.get(0);
      return authId?.token.toString().isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<AuthModel?> getAuth() async {
    AuthModel? userInfo = collection.get(0);

    try {
      if (userInfo != null) {
        await Future(() async {
          ApiRequest request = await authApi.getUser(userInfo.token);

          if (!request.error) {
            String jsonString = request.data;
            var jsonData = stringToJson(jsonString);

            print(jsonData);

            var authModel = AuthModel(
                token: userInfo.token,
                uid: jsonData['id'],
                userName: jsonData['username'],
                userEmail: jsonData['email']);
            collection.put(0, authModel);
            notifyListeners();
          }
        });
      } else {
        print("Error: AuthModel is null");
      }
    } catch (e) {
      print("Error: $e");
    }

    return collection.get(0);
  }

  void genericErrorMessage(BuildContext context,
      {required String title, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).splashColor,
        content: ListTile(
          title: Text(title),
          subtitle: Text(message),
        )));
  }

  void handleException(BuildContext context, dynamic e) {
    if (e is SocketException) {
      genericErrorMessage(context,
          title: "Error", message: ApiMsg.externalServerError);
    }
  }
}
