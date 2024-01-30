// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:portfolio_builder_app/control/conversions.dart';

import 'package:portfolio_builder_app/model/auth.dart';

import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/model/template_model.dart';
import 'package:portfolio_builder_app/view/api/api_prop.dart';

import 'package:portfolio_builder_app/view/api/template_api.dart';

class Bucket extends NotifyListener {
  TemplateApi templateApi = TemplateApi();
  Auth userInfo = Auth();
  Box<TemplateModel> templateCollection = Hive.box<TemplateModel>('templatedb');

  Future<List<dynamic>> fetchTemplates(BuildContext context) async {
    userInfo.getAuth().then((value) async {
      String? authToken = value?.token;

      try {
        ApiRequest request =
            await templateApi.getTemplates(authToken as String);

        if (request.error) {
          genericErrorMessage(context, title: "Error", message: request.data);
        }

        print(stringToJson(request.data));
      } catch (e) {
        handleException(context, e);
      }
    });

    return [];
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
