import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  void genericErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                child: Column(
                  children: <Widget>[
                    //username
                    MyTextField(
                      controller: usernameController,
                      hintText: 'Enter your username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 15),
                    //useremail
                    MyTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter your email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 15),
                    //password
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm your Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 15),

                    //signup button
                    ElevatedButton(
                        onPressed: signUserUp,
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
            ]),
          ),
        )));
  }
}
