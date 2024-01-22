import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_builder_app/control/config.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/view/components/mycard.dart';
import 'package:portfolio_builder_app/view/components/mylisttile.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:portfolio_builder_app/view/deserialization/portfolio_parsing.dart';
import 'package:portfolio_builder_app/view/deserialization/template_parsing.dart';

import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
    },
    {
      "label": const Text("Logout"),
      "icon": const Icon(Icons.logout),
      "selectedIcon": const Icon(Icons.logout_outlined)
    }
  ];

  @override
  void initState() {
    _selectedIndex = 1;
    super.initState();
  }

  void logOut(BuildContext context) async {
    try {
      auth.logoutUser();
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    } catch (e) {
      genericErrorMessage("Error",
          "could not log you out, try again or check your internet connection");
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Row(
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
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  const AddNewPage(),
                  PortfolioPage(),
                  TemplatePage(),
                  Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Image.asset(
                          "assets/images/3d-icons/info.png",
                          width: 224,
                          height: 224,
                        ),
                        const SizedBox(height: 32),
                        AutoSizeText(
                          "Confirm Logout",
                          style: Theme.of(context).textTheme.displayLarge,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 32),
                        AutoSizeText(
                          "Are you sure you want to Logout",
                          style: Theme.of(context).textTheme.headlineMedium,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedIndex = 1;
                                  });
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  child: Text(
                                    "No",
                                  ),
                                )),
                            ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.purple),
                                ),
                                onPressed: () {
                                  listener.setLoading(true);
                                  logOut(context);
                                  listener.setLoading(false);
                                },
                                child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Text(
                                      "Yes",
                                    )))
                          ],
                        )
                      ]))
                ],
              ),
            ),
          ],
        )));
  }
}

class AddNewPage extends StatefulWidget {
  const AddNewPage({
    super.key,
  });

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final _createPortfolioFormKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode templateFocusNode = FocusNode();

  final nameController = TextEditingController();
  String projectUrl = "";
  String templateId = "";

  @override
  void initState() {
    projectUrl = "";
    templateId = "";
    super.initState();
  }

  void createPortfolioProject(BuildContext context) async {
    try {
      Navigator.of(context).pushNamed(AppRoutes.form, arguments: "12345");
    } catch (e) {
      genericErrorMessage("Error", "could not create your project, try again");
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
    String appUrl = api["app"]["base_url"];

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
            margin: const EdgeInsets.only(left: 128, right: 128),
            child: Padding(
                padding: const EdgeInsets.all(32),
                child: SingleChildScrollView(
                    child: Form(
                  key: _createPortfolioFormKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(
                                "Create a new Portfolio Website",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge,
                                maxLines: 1,
                              ),
                            ]),
                        const SizedBox(
                          height: 32,
                        ),
                        //portfolioname
                        MyTextField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            hintText: 'Enter your Portfolio name',
                            obscureText: false,
                            maxLength: 25,
                            validator: validateField,
                            onChange: (value) {
                              setState(() {
                                projectUrl =
                                    validateUrl(nameController.text).toString();
                              });
                              return null;
                            }),
                        const SizedBox(
                          height: 32,
                        ),
                        Text("Project URL: $appUrl/project/$projectUrl"),
                        const SizedBox(
                          height: 32,
                        ),
                        FutureBuilder(
                          future: fetchTemplateData(),
                          builder: (context,
                              AsyncSnapshot<List<Template>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else {
                              return DropDownTextField(
                                textFieldDecoration: const InputDecoration(
                                    hintText: "Select your portfolio template"),
                                clearOption: true,
                                textFieldFocusNode: templateFocusNode,
                                searchFocusNode: searchFocusNode,
                                searchAutofocus: true,
                                dropDownItemCount: 8,
                                searchShowCursor: true,
                                enableSearch: true,
                                validator: validateDropdownField,
                                searchKeyboardType: TextInputType.text,
                                dropDownList: snapshot.data!.map((template) {
                                  return DropDownValueModel(
                                    name: template.name,
                                    value: template.description,
                                    toolTipMsg: template.name,
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),

                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  nameController.clear();
                                },
                                child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Text(
                                      "Reset",
                                    ))),
                            ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          Colors.purple),
                                ),
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_createPortfolioFormKey.currentState!
                                      .validate()) {
                                    listener.setLoading(true);

                                    createPortfolioProject(context);
                                    listener.setLoading(false);
                                  }
                                  return;
                                },
                                child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 16, right: 16, top: 8, bottom: 8),
                                    child: Text(
                                      "Create",
                                    )))
                          ],
                        )
                      ]),
                ))))
      ],
    ));
  }
}

class PortfolioPage extends StatelessWidget {
  PortfolioPage({
    super.key,
  });

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
          height: 32,
        ),
        Expanded(
            child: FutureBuilder(
          future: fetchPortfolioData(),
          builder: (context, AsyncSnapshot<List<Portfolio>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ResponsiveStaggeredGridList(
                desiredItemWidth: 240,
                minSpacing: 12,
                children: snapshot.data!.map((portfolio) {
                  return MyCard(
                    id: portfolio.id,
                    title: portfolio.name,
                    subtitle: portfolio.description,
                    image: portfolio.image,
                    onPressed: () {},
                  );
                }).toList(),
              );
            }
          },
        )),
      ],
    ));
  }
}

class TemplatePage extends StatelessWidget {
  TemplatePage({
    super.key,
  });

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
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
          height: 32,
        ),
        Expanded(
          child: FutureBuilder(
            future: fetchTemplateData(),
            builder: (context, AsyncSnapshot<List<Template>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null) {
                // Handle the case when snapshot.data is null
                return const Center(child: Text('Data is null'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final template = snapshot.data![index];
                    return MyListTile(
                      id: template.id,
                      title: template.name,
                      subtitle: template.description,
                      image: template.image,
                      onPressed: () {},
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ));
  }
}
