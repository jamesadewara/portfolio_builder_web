import 'package:flutter/material.dart';
import "package:portfolio_builder_app/control/page_list.dart";
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String form = '/form';
  static const String profile = '/profile';
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Object? args = settings.arguments;
    Auth auth = Auth();

    if (!auth.isLogged()) {
      switch (settings.name) {
        case AppRoutes.signup:
          return MaterialPageRoute(
              builder: (_) => const BaseApp(
                    pageIsLoading: false,
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
                  pageIsLoading: false,
                  child: DashboardScreen(),
                ));

      case AppRoutes.profile:
        return MaterialPageRoute(
            builder: (_) => const BaseApp(
                  pageIsLoading: false,
                  child: ProfileScreen(),
                ));

      case AppRoutes.form:

        // Validation of correct data type
        if (args != null) {
          return MaterialPageRoute(builder: (_) => FormScreen(id: args));
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
              pageIsLoading: false,
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
  const BaseApp({
    super.key,
    required this.child,
    required this.pageIsLoading,
  });

  final Widget child;
  final bool pageIsLoading;

  @override
  State<BaseApp> createState() => _BaseAppState();
}

class _BaseAppState extends State<BaseApp> {
  bool listener = true;
  @override
  void initState() {
    listener = widget.pageIsLoading;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool listener = context.watch<NotifyListener>().isLoading;
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      LinearProgressIndicator(
        value: widget.pageIsLoading
            ? null
            : listener
                ? null
                : 0,
      ),
      Expanded(child: widget.child)
    ]);
  }
}

class SettingsOption {
  final String title;
  final String? subtitle;
  final Icon? icon;
  final Function(BuildContext) onTap;

  SettingsOption(
      {required this.title, this.icon, this.subtitle, required this.onTap});
}
