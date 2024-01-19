import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
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

  void signUserUp(BuildContext context) async {
    try {
      auth.signupUser(usernameController.text, emailController.text,
          passwordController.text);
      Navigator.of(context).pushReplacementNamed("/dashboard");
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
                          onPressed: () {
                            if (_signupFormKey.currentState!.validate()) {
                              listener.setLoading(true);
                              signUserUp(context);
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
