// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:flutter/material.dart';

class WallpaperButton extends StatelessWidget {
  String title;
  VoidCallback onTap;
  Color color;
  double width;

  WallpaperButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: width,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
