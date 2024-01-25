// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _signupFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Auth auth = Auth();

  Future<void> signUserUp(BuildContext context) async {
    auth.signupUser(
      context,
      username: usernameController.text,
      password: passwordController.text,
      email: emailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    NotifyListener listener = context.watch<NotifyListener>();
    return Scaffold(
        appBar: AppBar(
            leading: Image.asset("assets/images/icon.png"),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back))
            ]),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 50),
              //logo
              AutoSizeText('SIGNUP',
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 240, right: 240),
                child: Form(
                  key: _signupFormKey,
                  child: Column(
                    children: <Widget>[
                      //username
                      MyTextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          hintText: 'Enter your username',
                          obscureText: false,
                          validator: validateUserName),

                      const SizedBox(height: 15),
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

                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm your Password',
                        obscureText: true,
                        validator: (value) {
                          if (value != passwordController.text) {
                            return "password does not match";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 15),

                      //signup button
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_signupFormKey.currentState!.validate()) {
                                listener.setLoading(true);
                                await signUserUp(context);
                              }
                            } finally {
                              listener.setLoading(false);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: Text('Sign Up'),
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
        )));
  }
}
