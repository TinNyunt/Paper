// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SettingButton extends StatelessWidget {
  VoidCallback onTap;
  String title;
  Color color;
  Color textcolor;

  SettingButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.color,
    required this.textcolor,
  });

  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, color: textcolor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
