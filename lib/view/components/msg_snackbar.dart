import 'package:flutter/material.dart';

class GenericMessage extends StatelessWidget {
  const GenericMessage({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
        backgroundColor: Theme.of(context).splashColor,
        content: ListTile(
          title: Text(title),
          subtitle: Text(message),
        ));
  }
}
