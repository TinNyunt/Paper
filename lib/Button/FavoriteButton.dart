// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  bool isLike = false;
  void Function()? onTap;

  FavoriteButton({
    super.key,
    required this.isLike,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                isLike ? Icons.favorite : Icons.favorite_outline,
                color: isLike ? Colors.red : Colors.black,
              )
            ],
          ),
        ),
      ),
    );
  }
}
