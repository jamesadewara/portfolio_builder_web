import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        CachedNetworkImage(
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              LinearProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        ListTile(
          title: Text(title),
          subtitle: Text(subtitle),
        )
      ]),
    );
  }
}
