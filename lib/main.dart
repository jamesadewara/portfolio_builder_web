import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provder;
import 'package:provider/provider.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/control/app_theme.dart';
import 'package:portfolio_builder_app/model/auth_model.dart';
import 'package:portfolio_builder_app/model/bucket_model.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await path_provder.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.initFlutter(directory.path);

  Hive.registerAdapter(AuthModelAdapter());
  Hive.registerAdapter(BucketModelAdapter());
  await Hive.openBox<AuthModel>('authdb');
  await Hive.openBox<BucketModel>('bucketdb');

  runApp(MultiProvider(
    providers: [
      ListenableProvider<NotifyListener>(
        create: (_) => NotifyListener(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Builder',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
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
