// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  bool isMark = false;
  void Function()? onTap;

  SaveButton({super.key, required this.isMark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isMark
                    ? Icons.bookmark_added_rounded
                    : Icons.bookmark_add_outlined,
                color: isMark ? Colors.blue[600] : Colors.white,
                weight: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
