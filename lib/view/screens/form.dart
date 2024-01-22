import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  final Object? id;

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController exampleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Portfolio Form: ${widget.id.toString()}"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Clipboard.setData(const ClipboardData(text: "your text"));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.purple,
                  content: ListTile(
                    title: Text(
                      "Portfolio web Page link copied",
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "try using the link on your web browser",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ));
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Text("Share Link"),
              ),
            ),
            const SizedBox(
              width: 32,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Text("Save"),
              ),
            ),
            const SizedBox(
              width: 64,
            ),
          ],
        ),
        body: const Center());
  }
}
