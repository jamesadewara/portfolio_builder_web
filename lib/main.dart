import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provder;
import 'package:portfolio_builder_app/control/page_list.dart';
import 'package:provider/provider.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/control/app_theme.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

Future<void> initHive() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provder.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.initFlutter(directory.path);

  Hive.registerAdapter(AuthModelAdapter());
  await Hive.openBox<AuthModel>('authdb');
}

void main() async {
  await initHive();
  runApp(MultiProvider(
    providers: [
      ListenableProvider<NotifyListener>(
        create: (_) => NotifyListener(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the starting point of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Splash',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => BaseApp(
              pageIsLoading: true,
              child: SplashScreen(
                duration: const Duration(seconds: 5),
              ),
            ),
        AppRoutes.home: (context) => const MainApp(),
      },
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Builder',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
