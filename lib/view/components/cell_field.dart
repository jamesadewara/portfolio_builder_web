import 'package:flutter/material.dart';

class CellField extends StatefulWidget {
  const CellField({
    super.key,
    required this.id,
    required this.type,
    required this.controller,
    required this.onPressed,
  });
  final String id;
  final String type;
  final TextEditingController controller;
  final VoidCallback onPressed;

  @override
  State<CellField> createState() => _CellFieldState();
}

class _CellFieldState extends State<CellField> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: widget.onPressed,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 8, bottom: 8),
                  child: Text(
                    widget.type,
                  ),
                )),
            TextFormField(
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: "Enter the name of your cell",
              ),
            )
          ],
        ));
  }
}
