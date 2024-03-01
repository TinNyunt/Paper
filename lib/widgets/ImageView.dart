// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:paper/Button/Bottomsheetbutton.dart';
import 'package:paper/Button/WallpaperButton.dart';
import 'package:photo_view/photo_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageView extends StatefulWidget {
  String img;
  ImageView({super.key, required this.img});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  SetWallpaper() async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              BottomSheetButton(
                title: "BothScreen Wallpaper",
                onTap: () async {
                  Navigator.pop(context);
                  await AsyncWallpaper.setWallpaper(
                    url: "${widget.img}",
                    wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
                  );
                  Fluttertoast.showToast(
                    msg: "Wallpaper applies sucessfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 15.0,
                  );
                },
                width: double.infinity,
                color: Colors.transparent,
              ),
              BottomSheetButton(
                title: "HomeScreen Wallpaper",
                onTap: () async {
                  Navigator.pop(context);
                  await AsyncWallpaper.setWallpaper(
                    url: "${widget.img}",
                    wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
                  );
                  Fluttertoast.showToast(
                    msg: "Wallpaper applies sucessfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 15.0,
                  );
                },
                width: double.infinity,
                color: Colors.transparent,
              ),
              BottomSheetButton(
                title: "LookScreen Wallpaper",
                onTap: () async {
                  Navigator.pop(context);
                  await AsyncWallpaper.setWallpaper(
                    url: "${widget.img}",
                    wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
                  );
                  Fluttertoast.showToast(
                    msg: "Wallpaper applies sucessfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 15.0,
                  );
                },
                width: double.infinity,
                color: Colors.transparent,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: PhotoView(imageProvider: NetworkImage(widget.img)),
            ),
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                alignment: Alignment.bottomCenter,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                  child: Column(
                    children: [
                      WallpaperButton(
                        title: "Wallpaper",
                        onTap: SetWallpaper,
                        width: 250,
                        color: Color.fromARGB(255, 60, 60, 60).withOpacity(.5),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Material(
                            color: Colors.black.withOpacity(.5),
                            borderRadius: BorderRadius.circular(5),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: IconButton(
                                onPressed: () async {
                                  final imagePath =
                                      '${Directory.systemTemp.path}/image.jpg';
                                  await Dio()
                                      .download('${widget.img}', imagePath);
                                  await Gal.putImage(imagePath);
                                  Fluttertoast.showToast(
                                    msg: "Save to gallery",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                },
                                icon: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
