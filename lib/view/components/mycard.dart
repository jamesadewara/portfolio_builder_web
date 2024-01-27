import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.onPressed,
  });
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onPressed,
      child: Column(children: [
        CachedNetworkImage(
          height: 180,
          imageUrl: image,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child: LinearProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) =>
              Image.asset("assets/images/icon.png"),
        ),
        ListTile(
          title: AutoSizeText(title),
          subtitle: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ]),
    ));
  }
}
