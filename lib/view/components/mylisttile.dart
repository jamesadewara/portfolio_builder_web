import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  const MyListTile({
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
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  bool isDownloading = false;
  @override
  void initState() {
    isDownloading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onPressed,
      leading: CachedNetworkImage(
        height: 180,
        imageUrl: widget.image,
        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: LinearProgressIndicator(value: downloadProgress.progress)),
        errorWidget: (context, url, error) =>
            Image.asset("assets/images/icon.png"),
      ),
      title: AutoSizeText(widget.title),
      subtitle: Text(
        widget.subtitle,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
      trailing: Column(
        children: <Widget>[
          Visibility(
            visible: isDownloading,
            child: Stack(children: <Widget>[
              const CircularProgressIndicator(),
              IconButton(
                  onPressed: () {
                    setState(() {
                      isDownloading = false;
                    });
                  },
                  icon: const Icon(Icons.close))
            ]),
          ),
          Visibility(
              visible: !isDownloading,
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      isDownloading = true;
                    });
                  },
                  icon: const Icon(Icons.download)))
        ],
      ),
    );
  }
}
