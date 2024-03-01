// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paper/Button/BottomSheetIconButton.dart';
import 'package:flutter/material.dart';

import '../../widgets/ImageView.dart';

class LibraryCard extends StatefulWidget {
  String img;
  String id;
  String uid;
  LibraryCard({
    super.key,
    required this.img,
    required this.id,
    required this.uid,
  });

  @override
  State<LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  DeleteLibrary() async {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(20),
          child: Wrap(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Your Library',
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
              ),
              BottomSheetIconButton(
                iconcolor: Colors.red,
                icon: Icons.favorite,
                title: "Add to favorite",
                onTap: () {
                  Navigator.pop(context);
                  FirebaseFirestore.instance
                      .collection('Library')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection('Items')
                      .doc(widget.id)
                      .set(
                    {
                      "image": widget.img,
                      "category": "favorite",
                      "uid": widget.uid,
                    },
                  );
                },
                width: double.infinity,
                color: Colors.transparent,
              ),
              BottomSheetIconButton(
                iconcolor: Colors.blue,
                icon: Icons.delete,
                title: "Remove from library",
                onTap: () {
                  Navigator.pop(context);
                  FirebaseFirestore.instance
                      .collection('Library')
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection('Items')
                      .doc(widget.id)
                      .delete();
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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageView(img: widget.img),
        ),
      ),
      onLongPress: DeleteLibrary,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: widget.img,
          imageBuilder: (context, imageProvioder) {
            return Image(
              image: imageProvioder,
              width: double.infinity,
              fit: BoxFit.cover,
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
    );
  }
}
