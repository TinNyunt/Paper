// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class BottomNavigate extends StatelessWidget {
  void Function(int)? onTabChange;
  int Selectindex = 0;
  BottomNavigate(
      {super.key, required this.onTabChange, required this.Selectindex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 30,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BottomNavigationBar(
          currentIndex: Selectindex,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          onTap: (value) => onTabChange!(value),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                color: Selectindex == 0 ? Colors.blue[300] : Colors.black,
                size: 30,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.sort,
                color: Selectindex == 1 ? Colors.blue[300] : Colors.black,
                size: 30,
              ),
              label: "Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark_border_outlined,
                color: Selectindex == 2 ? Colors.blue[300] : Colors.black,
                size: 30,
              ),
              label: "Your Library",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Selectindex == 3 ? Colors.blue[300] : Colors.black,
                size: 30,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
