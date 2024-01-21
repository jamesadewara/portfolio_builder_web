import 'package:flutter/material.dart';
import "package:portfolio_builder_app/control/page_list.dart";
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String portfolio = '/portfolio';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    Auth auth = Auth();

    if (!auth.isLogged()) {
      switch (settings.name) {
        case AppRoutes.signup:
          return MaterialPageRoute(
              builder: (_) => const BaseApp(
                    child: SignupScreen(),
                  ));
        case AppRoutes.login:
          return redirectAuthRoute();
        default:
          return redirectAuthRoute();
      }
    }

    switch (settings.name) {
      case AppRoutes.dashboard:
        return MaterialPageRoute(
            builder: (_) => const BaseApp(
                  child: DashboardScreen(),
                ));

      case AppRoutes.portfolio:

        // Validation of correct data type
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text("Logout now")),
                  ));
        }
        return _errorRoute();

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
    listener.setLoading(false);

    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      LinearProgressIndicator(
        value: listener.isLoading ? null : 0,
      ),
      Expanded(child: widget.child)
    ]);
  }
}
