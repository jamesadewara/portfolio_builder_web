import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;

  Auth auth = Auth();

  @override
  void initState() {
    usernameController = TextEditingController();
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NotifyListener listener = context.watch<NotifyListener>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Profile'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // logo
                AutoSizeText(
                  'Account Profile',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 25),
                Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveBreakpoints.of(context)
                                  .between(MOBILE, TABLET) ||
                              ResponsiveBreakpoints.of(context).isMobile
                          ? 12
                          : 240,
                    ),
                    child: FutureBuilder<AuthModel?>(
                      future: auth.getAuth(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Show a loading indicator while fetching data
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Handle errors
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          // Handle the case where no user data is available
                          return const Text('No user data found.');
                        } else {
                          // User data is available, update the UI
                          AuthModel userInfo = snapshot.data!;
                          // Use null-aware operators to safely access the properties
                          usernameController.text = userInfo.userName ?? '';
                          emailController.text = userInfo.userEmail ?? '';

                          return Form(
                            key: _profileFormKey,
                            child: Column(
                              children: <Widget>[
                                MyTextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  enabled: false,
                                  hintText: 'Fetching email...',
                                  obscureText: false,
                                ),
                                const SizedBox(height: 15),
                                // username
                                MyTextField(
                                  controller: usernameController,
                                  keyboardType: TextInputType.text,
                                  hintText: 'Enter your username',
                                  obscureText: false,
                                  validator: validateUserName,
                                ),

                                const SizedBox(height: 15),
                                // Profile button
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_profileFormKey.currentState!
                                        .validate()) {
                                      listener.setLoading(true);
                                      auth.updateUser(context,
                                          username: usernameController.text);
                                      Timer(const Duration(seconds: 2), () {
                                        listener.setLoading(false);
                                      });
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Text('Update'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
