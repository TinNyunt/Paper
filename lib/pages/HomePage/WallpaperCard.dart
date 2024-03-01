// ignore_for_file: must_call_super, non_constant_identifier_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paper/Button/Bottomsheetbutton.dart';
import 'package:paper/Button/FavoriteButton.dart';
import 'package:paper/Button/SaveButton.dart';
import 'package:paper/pages/DetailPages/DetailPage.dart';
import 'package:paper/widgets/ImageView.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WallpaperCard extends StatefulWidget {
  String title;
  String img;
  final List<String> favorite;
  String PostId;
  String username;
  String createAt;
  String description;
  String uid;

  WallpaperCard({
    super.key,
    required this.title,
    required this.img,
    required this.favorite,
    required this.PostId,
    required this.username,
    required this.createAt,
    required this.description,
    required this.uid,
  });

  @override
  State<WallpaperCard> createState() => _WallpaperCardState();
}

class _WallpaperCardState extends State<WallpaperCard> {
  bool isFavorite = false;
  bool isMark = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    isFavorite = widget.favorite.contains(auth.currentUser?.email);
  }

  FavoriteWallpaper() async {
    if (isFavorite) {
      FirebaseFirestore.instance
          .collection("WallpaperInfo")
          .doc(widget.PostId)
          .update({
        "PostFavorite": FieldValue.arrayRemove([auth.currentUser!.email]),
      });
    } else {
      FirebaseFirestore.instance
          .collection("WallpaperInfo")
          .doc(widget.PostId)
          .update({
        "PostFavorite": FieldValue.arrayUnion([auth.currentUser!.email]),
      });
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  AddYourLibrary(context) async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Save Library',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ),
              BottomSheetButton(
                title: "Default",
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection('Library')
                      .doc(auth.currentUser!.email)
                      .collection('Items')
                      .doc(widget.PostId)
                      .set({
                    "image": widget.img,
                    "category": "default",
                    "uid": widget.uid,
                  });
                },
                width: double.infinity,
                color: Colors.transparent,
              ),
              BottomSheetButton(
                title: "Your Favorite",
                onTap: () async {
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection('Library')
                      .doc(auth.currentUser!.email)
                      .collection('Items')
                      .doc(widget.PostId)
                      .set({
                    "image": widget.img,
                    "category": "favorite",
                    "uid": widget.uid,
                  });
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
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ImageView(img: widget.img),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: widget.img,
              imageBuilder: (context, imageProvioder) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Image(
                    width: double.infinity,
                    height: double.infinity,
                    image: imageProvioder,
                    fit: BoxFit.cover,
                  ),
                );
              },
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                )
              ],
            ),
            child: SaveButton(
              isMark: isMark,
              onTap: () => AddYourLibrary(context),
            ),
          ),
        ),
        Positioned(
          child: Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      blurRadius: 40,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return DetailPage(
                                description: widget.description,
                                title: widget.title,
                                img: widget.img,
                                createAt: widget.createAt,
                                username: widget.username,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: 125,
                        child: Text(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    FavoriteButton(
                      isLike: isFavorite,
                      onTap: FavoriteWallpaper,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
