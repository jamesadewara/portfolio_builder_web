import 'package:flutter/material.dart';
import "package:portfolio_builder_app/control/page_list.dart";
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    Auth auth = Auth();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BaseApp(
              child: SplashScreen(
            duration: const Duration(seconds: 5),
          )),
        );

      case '/login':
        return MaterialPageRoute(
            builder: (_) => const BaseApp(
                  child: LoginScreen(),
                ));

      case '/signup':
        return MaterialPageRoute(
            builder: (_) => const BaseApp(
                  child: SignupScreen(),
                ));

      case '/dashboard':
        if (!auth.isLogged()) {
          return redirectAuthRoute();
        } else {
          return MaterialPageRoute(
              builder: (_) => const BaseApp(
                    child: DashboardScreen(),
                  ));
        }

      case '/portfolio':
        if (!auth.isLogged()) {
          return redirectAuthRoute();
        } else {
          // Validation of correct data type
          if (args is String) {
            return MaterialPageRoute(
                builder: (_) => Center(
                      child: ElevatedButton(
                          onPressed: () {
                            auth.logoutUser();
                          },
                          child: const Text("Logout now")),
                    ));
          }

          // If args is not of the correct type, return an error page.
          // You can also throw an exception while in development.
          return _errorRoute();
        }

      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static MaterialPageRoute redirectAuthRoute() {
    return MaterialPageRoute(
        builder: (_) => const BaseApp(
              child: LoginScreen(),
            ));
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const ErrorPage();
    });
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/dashboard',
            );
          },
        ),
        title: const Text('Oops'),
      ),
      body: const Center(
        child: Text(
          'Oops, something went wrong. Please try again or go back to your previous page',
          softWrap: true,
        ),
      ),
    );
  }
}

class BaseApp extends StatefulWidget {
  const BaseApp({super.key, required this.child});

  final Widget child;
  @override
  State<BaseApp> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  @override
  Widget build(BuildContext context) {
    NotifyListener listener = context.watch<NotifyListener>();
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      LinearProgressIndicator(
        value: listener.isLoading ? null : 0,
      ),
      Expanded(child: widget.child)
    ]);
  }
}
