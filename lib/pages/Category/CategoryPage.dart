import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paper/pages/HomePage/WallpaperCard.dart';
import 'package:timeago/timeago.dart' as timeago;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Stream<QuerySnapshot> postsStream;
  final List<String> _options = [
    "Default",
    'Wallpaper',
    'Anime',
    'Game',
    'Enviroment',
    "Scientist",
    "Coding",
  ];
  String categoryChip = 'Default';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Categories',
            style: TextStyle(color: Colors.lightBlue[400], fontSize: 30),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 0, 0, 0),
              child: Wrap(
                spacing: 5,
                runSpacing: 4,
                children: List<Widget>.generate(
                  _options.length,
                  (int index) {
                    return ChoiceChip(
                      label: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(_options[index]),
                      ),
                      backgroundColor: Colors.white,
                      elevation: 0.5,
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: _selectedIndex == index
                            ? Colors.white
                            : Colors.black,
                      ),
                      selected: _selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          categoryChip = _options[index];
                          _selectedIndex = (selected ? index : null)!;
                        });
                      },
                    );
                  },
                ).toList(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('WallpaperInfo')
                      .where('category', isEqualTo: categoryChip)
                      .snapshots(),
                  builder: (context, snapshot) {
                    var data = snapshot.data?.docs;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Wallpaper with category..',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1.5),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemBuilder: (context, index) {
                        return WallpaperCard(
                          title: data[index]['title'],
                          img: data[index]['img'],
                          favorite: List<String>.from(
                              data[index]["PostFavorite"] ?? []),
                          PostId: data[index].id,
                          username: data[index]['username'],
                          createAt:
                              timeago.format(data[index]['craeteat'].toDate()),
                          description: data[index]['description'],
                          uid: data[index]['uid'],
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
