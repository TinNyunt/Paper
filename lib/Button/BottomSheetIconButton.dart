// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BottomSheetIconButton extends StatelessWidget {
  Color color;
  VoidCallback onTap;
  double width;
  String title;
  IconData icon;
  Color iconcolor;

  BottomSheetIconButton({
    super.key,
    required this.color,
    required this.onTap,
    required this.width,
    required this.title,
    required this.icon,
    required this.iconcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
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
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: iconcolor,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
