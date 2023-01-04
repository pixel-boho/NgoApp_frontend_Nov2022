import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatefulWidget {
  final String image;
  final bool networkImage;
  const PhotoViewer({Key key, this.image, this.networkImage = false})
      : super(key: key);

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.networkImage
          ? PhotoView(
        enableRotation: true,
        imageProvider: NetworkImage(widget.image),
      )
          : PhotoView(
        enableRotation: true,
        imageProvider: AssetImage(widget.image),
      ),
    );
  }
}
