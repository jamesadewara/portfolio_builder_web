import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Auth auth = Auth();

  void signUserIn(BuildContext context) async {
    try {
      auth.loginUser(emailController.text, passwordController.text);
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } catch (e) {
      genericErrorMessage("Error", "could not log you in, try again");
    }
  }

  void genericErrorMessage(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).splashColor,
        content: ListTile(
          title: Text(title),
          subtitle: Text(message),
        )));
  }

  @override
  Widget build(BuildContext context) {
    NotifyListener listener = context.watch<NotifyListener>();

    return Scaffold(
      appBar: AppBar(
          leading: Image.asset("assets/images/icon.png"),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.signup);
                },
                child: const Text("Create an account"))
          ]),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 50),
              //logo
              const Icon(
                Icons.lock_person,
                size: 120,
              ),
              const SizedBox(height: 10),
              //welcome back you been missed

              AutoSizeText('LOGIN',
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 240, right: 240),
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      //useremail
                      MyTextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email',
                          obscureText: false,
                          validator: validateUserEmail),
                      const SizedBox(height: 15),
                      //password
                      MyTextField(
                        controller: passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: validateUserPassword,
                      ),

                      const SizedBox(height: 15),

                      //sign in button
                      ElevatedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false otherwise.
                            if (_loginFormKey.currentState!.validate()) {
                              listener.setLoading(true);
                              signUserIn(context);
                              listener.setLoading(false);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: Text('SignIn'),
                          )),

                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
