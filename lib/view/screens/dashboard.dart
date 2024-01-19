import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Auth auth = Auth();
  int _selectedIndex = 0;
  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NotifyListener listener = context.watch<NotifyListener>();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Row(
          children: <Widget>[
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              // backgroundColor: Theme.of(context).,
              // selectedIconTheme: const IconThemeData(color: Colors.white),
              // unselectedIconTheme: const IconThemeData(color: Colors.white),
              // selectedLabelTextStyle: const TextStyle(color: Colors.white),
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                    padding: EdgeInsets.all(16),
                    icon: Icon(Icons.dashboard_outlined),
                    selectedIcon: Icon(Icons.dashboard),
                    label: Text("")),
                NavigationRailDestination(
                    padding: EdgeInsets.all(16),
                    icon: Icon(Icons.recommend_outlined),
                    selectedIcon: Icon(Icons.recommend),
                    label: Text("")),
                NavigationRailDestination(
                    padding: EdgeInsets.all(16),
                    icon: Icon(Icons.logout_outlined),
                    selectedIcon: Icon(Icons.logout),
                    label: Text(""))
              ],
            ),
            const VerticalDivider(
              thickness: 1,
              width: 2,
            ),
          ],
        )));
  }
}
