import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/model/notifier_listener.dart';
import 'package:portfolio_builder_app/view/deserialization/portfolio_parsing.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Auth auth = Auth();
  int _selectedIndex = 0;

  List<Map<dynamic, Widget>> navIcons = [
    {
      "label": const Text("Create New"),
      "icon": const Icon(Icons.add),
      "selectedIcon": const Icon(Icons.add)
    },
    {
      "label": const Text("Portfolios"),
      "icon": const Icon(Icons.dashboard),
      "selectedIcon": const Icon(Icons.dashboard_outlined)
    },
    {
      "label": const Text("Templates"),
      "icon": const Icon(Icons.recommend),
      "selectedIcon": const Icon(Icons.recommend_outlined)
    }
  ];

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
        body: SafeArea(child: sideNavBar(context)));
  }

  Row sideNavBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        NavigationRail(
          leading: Image.asset(
            "assets/images/icon.png",
            width: 48,
            height: 48,
          ),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          minWidth: 78,
          useIndicator: true,
          extended: true,
          indicatorShape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          // labelType: NavigationRailLabelType.all,
          // backgroundColor: Theme.of(context).,
          // selectedIconTheme: const IconThemeData(color: Colors.white),
          // unselectedIconTheme: const IconThemeData(color: Colors.white),
          // selectedLabelTextStyle: const TextStyle(color: Colors.white),
          destinations: navIcons.map((e) {
            return NavigationRailDestination(
                icon: e["icon"]!,
                selectedIcon: e["selectedIcon"],
                label: e["label"]!);
          }).toList(),
        ),
        const VerticalDivider(
          thickness: 1,
          width: 2,
        ),
        PortfolioPage(currentIndex: _selectedIndex),
        TemplatePage(currentIndex: _selectedIndex),
      ],
    );
  }
}

class PortfolioPage extends StatelessWidget {
  PortfolioPage({super.key, required this.currentIndex});
  final int currentIndex;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: currentIndex == 1,
        child: Expanded(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 64,
            ),
            SearchBar(
              controller: _searchController,
              hintText: 'Type to search for your portfolios',
              leading: const Icon(Icons.search),
              trailing: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              ],
              onChanged: (String value) {},
            ),
            const SizedBox(
              height: 64,
            ),
            FutureBuilder(
              future: fetchPortfolioData(),
              builder: (context, AsyncSnapshot<List<Portfolio>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                    itemBuilder: (context, index) {
                      final myData = snapshot.data![index];
                      return ListTile(
                        title: Text(myData.name),
                        subtitle: Text(myData.description),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ))));
  }
}

class TemplatePage extends StatelessWidget {
  TemplatePage({super.key, required this.currentIndex});
  final int currentIndex;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: currentIndex == 2,
        child: Expanded(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 64,
            ),
            SearchBar(
              controller: _searchController,
              hintText: 'Type to search for templates',
              leading: const Icon(Icons.search),
              trailing: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              ],
              onChanged: (String value) {},
            ),
            const SizedBox(
              height: 64,
            ),
            FutureBuilder(
              future: fetchPortfolioData(),
              builder: (context, AsyncSnapshot<List<Portfolio>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final myData = snapshot.data![index];
                      return ListTile(
                        title: Text(myData.name),
                        subtitle: Text(myData.description),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ))));
  }
}
