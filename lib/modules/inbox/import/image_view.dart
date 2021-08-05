import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'spin_loader.dart';

class ImageViewNetwork extends StatelessWidget {
  final String url;
  final String cacheFilePath;
  final int w, h;
  final double borderRadius;
  ImageViewNetwork(
      {@required this.url,
      this.w,
      this.h,
      this.borderRadius = 0,
      this.cacheFilePath});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailImageScreen(
            url,
            scaleW: w,
            scaleH: h,
          );
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: url == null
            ? Image.file(
                File(cacheFilePath),
                fit: BoxFit.cover,
              )
            : Image(
                image: CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
                errorBuilder: imageNetworkErrorBuilder,
                loadingBuilder: cacheFilePath != null
                    ? (_, __, ___) => Image.file(File(cacheFilePath))
                    : kLoadingBuilder,
              ),
      ),
    );
  }
}

class DetailImageScreen extends StatelessWidget {
  final String url;
  final String tag;
  final int scaleW, scaleH;
  DetailImageScreen(this.url, {this.tag, this.scaleW, this.scaleH});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.black87),
              imageProvider: NetworkImage(
                url,
              ),
              errorBuilder: (_, __, ___) => SizedBox.shrink(),
              loadingBuilder: (context, event) => PhotoView(
                backgroundDecoration: BoxDecoration(color: Colors.black87),
                imageProvider: NetworkImage(
                  url,
                ),
                loadingBuilder: (context, event) => Center(
                  child: kLoadingSpinner,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).maybePop();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class ImageViewNetworkCache extends StatelessWidget {
  final String filePath;
  final int w, h;
  final double borderRadius;
  ImageViewNetworkCache(
      {this.filePath,
      this.w,
      this.h,
      this.borderRadius = 0});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailImageScreenCache(
            filePath,
            scaleW: w,
            scaleH: h,
          );
        }));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
                File(filePath),
                fit: BoxFit.cover,
              )
           ,
      ),
    );
  }
}

class DetailImageScreenCache extends StatelessWidget {
  final String filePath;
  final String tag;
  final int scaleW, scaleH;
  DetailImageScreenCache(this.filePath, {this.tag, this.scaleW, this.scaleH});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(fit: StackFit.expand, children: [
          Center(
            child: PhotoView(
              backgroundDecoration: BoxDecoration(color: Colors.black87),
              imageProvider: FileImage(
                File(filePath),
              ),
              errorBuilder: (_, __, ___) => SizedBox.shrink(),
              
            ),
          ),
          Positioned(
            top: 50,
            right: 10,
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).maybePop();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20)),
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}