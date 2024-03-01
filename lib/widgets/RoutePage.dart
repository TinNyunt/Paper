// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:paper/pages/Bookmark/Bookmark.dart';
import 'package:paper/pages/Category/CategoryPage.dart';
import 'package:paper/pages/HomePage/HomePage.dart';
import 'package:paper/pages/ProfilePage/ProfilePage.dart';
import 'package:paper/widgets/BottomNavigationBar.dart';

class RoutePage extends StatefulWidget {
  RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int currentIndex = 0;
  final List<Widget> _Pages = [
    const HomePage(),
    const CategoryPage(),
    const BookmarkPage(),
    const ProfilePage(),
  ];

  void NavigateSelectBar(index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _Pages[currentIndex],
      bottomNavigationBar: BottomNavigate(
          onTabChange: (index) => NavigateSelectBar(index),
          Selectindex: currentIndex,),
    );
  }
}
