// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_list_view/flutter_list_view.dart';
import 'package:portfolio_builder_app/control/config.dart';
import 'package:portfolio_builder_app/control/route_generator.dart';
import 'package:portfolio_builder_app/control/validators.dart';
import 'package:portfolio_builder_app/model/auth.dart';
import 'package:portfolio_builder_app/control/notifier_listener.dart';
import 'package:portfolio_builder_app/view/components/msg_snackbar.dart';
import 'package:portfolio_builder_app/view/components/mycard.dart';
import 'package:portfolio_builder_app/view/components/mylisttile.dart';
import 'package:portfolio_builder_app/view/components/mytextfield.dart';
import 'package:portfolio_builder_app/view/deserialization/portfolio_parsing.dart';
import 'package:portfolio_builder_app/view/deserialization/template_parsing.dart';

import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Auth auth = Auth();
  int _selectedIndex = 0;

  List<Map<String, dynamic>> navIcons = [
    {"label": "Create New", "icon": Icons.add, "selectedIcon": Icons.add},
    {
      "label": "Portfolios",
      "icon": Icons.dashboard,
      "selectedIcon": Icons.dashboard_outlined
    },
    {
      "label": "Templates",
      "icon": Icons.recommend,
      "selectedIcon": Icons.recommend_outlined
    },
    {
      "label": "Settings",
      "icon": Icons.settings,
      "selectedIcon": Icons.settings_outlined
    }
  ];

  @override
  void initState() {
    _selectedIndex = 1;
    super.initState();
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
    String tutorialUrl = api["app"]["tutorial"];

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: Image.asset(
            "assets/images/icon.png",
            width: 48,
            height: 48,
          ),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () {
                  launchUrl(Uri(
                    scheme: 'https',
                    path: tutorialUrl,
                  ));
                },
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    "Watch Tutorial",
                  ),
                )),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        bottomNavigationBar: Visibility(
          visible: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET),
          child: BottomNavigationBar(
              elevation: 2,
              selectedItemColor: Colors.purple,
              unselectedItemColor: Theme.of(context).colorScheme.outline,
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: navIcons.map((e) {
                return BottomNavigationBarItem(
                    icon: Icon(e["icon"]!),
                    activeIcon: Icon(e["selectedIcon"]),
                    label: e["label"]);
              }).toList()),
        ),
        body: SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Visibility(
              visible:
                  !ResponsiveBreakpoints.of(context).between(MOBILE, TABLET),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  NavigationRail(
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
                          icon: Icon(e["icon"]!),
                          selectedIcon: Icon(e["selectedIcon"]),
                          label: Text(e["label"]!));
                    }).toList(),
                  ),
                  const VerticalDivider(
                    thickness: 1,
                    width: 2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: [
                const AddNewPage(),
                PortfolioPage(),
                TemplatePage(),
                SettingsPage()
              ]),
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
            margin: EdgeInsets.only(
                left: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
                    ? 12
                    : 128,
                right: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
                    ? 12
                    : 128),
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
                        Center(
                          child: AutoSizeText(
                            "Create a new Portfolio Website",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge,
                            maxLines: 2,
                          ),
                        ),
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
                          future: fetchTemplateData(context),
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
                        ),
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
        SizedBox(
          height: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
              ? 12
              : 64,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: SearchBar(
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
        ),
        SizedBox(
          height: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
              ? 8
              : 32,
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
    ScaffoldMessenger.of(context).showSnackBar(
        const GenericMessage(title: "title", message: "message") as SnackBar);
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
              ? 12
              : 64,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: SearchBar(
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
        ),
        SizedBox(
          height: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
              ? 8
              : 32,
        ),
        Expanded(
          child: FutureBuilder(
            future: fetchTemplateData(context),
            builder: (context, AsyncSnapshot<List<Template>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.data == null) {
                // Handle the case when snapshot.data is null
                return const Center(child: Text('Data is null'));
              } else {
                var template = snapshot.data;
                return FlutterListView(
                    delegate: FlutterListViewDelegate(
                        (BuildContext context, index) => MyListTile(
                              id: template![index].id,
                              title: template[index].name,
                              subtitle: template[index].description,
                              image: ResponsiveBreakpoints.of(context)
                                      .between(MOBILE, TABLET)
                                  ? template[index].mobileImage
                                  : template[index].defaultImage,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ImageDialog(
                                      image: ResponsiveBreakpoints.of(context)
                                              .between(MOBILE, TABLET)
                                          ? template[index].mobileImage
                                          : template[index].defaultImage,
                                    );
                                  },
                                );
                              },
                            ),
                        childCount: template?.length));
              }
            },
          ),
        ),
      ],
    ));
  }
}

class SettingsPage extends StatelessWidget {
  final List<SettingsOption> settingsOptions = [
    SettingsOption(
        title: 'User Accounts',
        subtitle: 'Manage your accounts',
        icon: const Icon(Icons.verified_user),
        onTap: (BuildContext context) {
          Navigator.pushNamed(context, AppRoutes.profile);
        }),
    SettingsOption(
      title: 'Logout',
      subtitle: null,
      icon: const Icon(Icons.logout),
      onTap: (BuildContext context) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return const MyLogoutConfirmationDialog();
          },
        );
      },
    ),
    SettingsOption(
      title: 'Delete Account',
      subtitle: 'Once deleted, you can not recover it back',
      icon: const Icon(Icons.delete),
      onTap: (BuildContext context) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return const DeleteAccountDialog();
          },
        );
      },
    ),
    SettingsOption(
        title: 'App Version',
        subtitle: api["app"]["version"],
        icon: const Icon(Icons.info),
        onTap: (BuildContext context) {}),
    SettingsOption(
        title: 'Exit App',
        subtitle: null,
        icon: const Icon(Icons.exit_to_app),
        onTap: (BuildContext context) {
          Navigator.of(context).pop();
          SystemNavigator.pop();
        })
  ];

  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: settingsOptions.length,
        itemBuilder: (context, index) {
          SettingsOption option = settingsOptions[index];
          return Padding(
            padding: EdgeInsets.only(
                top: 12,
                left: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
                    ? 8
                    : 120,
                right: ResponsiveBreakpoints.of(context).between(MOBILE, TABLET)
                    ? 8
                    : 120),
            child: Card(
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                leading: option.icon,
                title: Text(option.title),
                subtitle:
                    option.subtitle != null ? Text(option.subtitle!) : null,
                onTap: () => option.onTap(context),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String image;
  const ImageDialog({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: image,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child:
                      LinearProgressIndicator(value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset("assets/images/icon.png"),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context, true);
                  }),
            )
          ],
        ));
  }
}

class MyLogoutConfirmationDialog extends StatelessWidget {
  const MyLogoutConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    NotifyListener listener = context.watch<NotifyListener>();

    Future<void> logoutUser(BuildContext context) async {
      auth.logoutUser(context);
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/images/3d-icons/info.png",
              width: 224,
              height: 224,
            ),
            const SizedBox(height: 4),
            AutoSizeText(
              "Confirm Logout",
              style: Theme.of(context).textTheme.displayLarge,
              maxLines: 1,
            ),
            const SizedBox(height: 32),
            AutoSizeText(
              "Are you sure you want to Logout",
              style: Theme.of(context).textTheme.displaySmall,
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("No"),
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.purple),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    listener.setLoading(true);
                    logoutUser(context);
                    Timer(const Duration(seconds: 2), () {
                      listener.setLoading(false);
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Yes"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  Auth auth = Auth();
  final GlobalKey<FormState> _deleteFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool isVerified = false;

  @override
  void initState() {
    isVerified = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? userEmail = auth.collection.get(0)?.userEmail;
    NotifyListener listener = context.watch<NotifyListener>();
    return AlertDialog(
      title: const Text('Delete Account'),
      content: Form(
        key: _deleteFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Please enter your email to confirm account deletion:'),
            const SizedBox(height: 10),
            MyTextField(
                controller: _emailController,
                onChange: (value) {
                  setState(() {
                    if (value == userEmail) {
                      isVerified = true;
                    }
                  });
                  return null;
                },
                validator: validateUserEmail),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isVerified
              ? () {
                  // Validate the form
                  if (_deleteFormKey.currentState?.validate() == true) {
                    listener.setLoading(true);
                    auth.deleteUser(context);
                    Timer(const Duration(seconds: 2), () {
                      listener.setLoading(false);
                    });
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            onPrimary: Colors.white,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
