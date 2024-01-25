// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/view/api/api_prop.dart';
import 'package:portfolio_builder_app/view/api/auth_api.dart';

class Auth extends NotifyListener {
  AuthApi authApi = AuthApi();
  Box<AuthModel> collection = Hive.box<AuthModel>('authdb');

  Future<void> signupUser(BuildContext context,
      {required String username,
      required String email,
      required String password}) async {
    Map<String, dynamic> signupData = {
      "username": username,
      "email": email,
      "password": password,
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
    Map<String, dynamic> signinData = {
      "email": email,
      "password": password,
    };

    try {
      ApiRequest request = await authApi.signin(signinData);

      if (request.error) {
        genericErrorMessage(context, title: "Error", message: request.data);
      } else {
        String jsonString = request.data;

        // Remove the outer double quotes and unescape the string
        jsonString = jsonString.substring(1, jsonString.length - 1);
        jsonString = jsonString.replaceAll(r'\"', '"');

        // Parse the string as JSON
        Map<String, dynamic> jsonData = json.decode(jsonString);

        // Access the value of "access"
        String accessValue = jsonData['access'];
        print(accessValue);

        var authModel = AuthModel(uid: accessValue);
        collection.put(0, authModel);
        onChange();

        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    } catch (e) {
      handleException(context, e);
    }
  }

  void logoutUser(BuildContext context) async {
    try {
      ApiRequest request = await authApi.signout(getAuth()!.uid);

      if (request.error) {
        genericErrorMessage(context, title: "Error", message: request.data);
      } else {
        collection.clear();
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, AppRoutes.login);
        notifyListeners();
      }
    } catch (e) {
      handleException(context, e);
    }
  }

  bool isLogged() {
    try {
      AuthModel? authId = collection.get(0);
      return authId?.uid.toString().isNotEmpty ?? false;
    } catch (e) {
      return false;
    }
  }

  AuthModel? getAuth() {
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
