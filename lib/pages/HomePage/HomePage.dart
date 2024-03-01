import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paper/pages/HomePage/WallpaperCard.dart';
import 'package:paper/pages/public/WallpaperPublic.dart';
import 'package:timeago/timeago.dart' as timeago;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  bool isShowPost = false;
  List Results = [];
  List getResult = [];
  bool isLoading = false;

  late Stream<QuerySnapshot> postsStream;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    getSearchFetch();
    searchController.removeListener(_onsearch);
    postsStream = FirebaseFirestore.instance
        .collection('WallpaperInfo')
        .orderBy('craeteat', descending: true)
        .snapshots();
  }

  _onsearch() {
    var showResult = [];
    if (searchController.text != '') {
      for (var snap in Results) {
        var name = snap['title'].toString().toLowerCase();
        if (name.contains(searchController.text.toLowerCase())) {
          showResult.add(snap);
        }
      }
    } else {
      showResult = List.from(Results);
    }

    setState(() {
      getResult = showResult;
      isShowPost = true;
    });
  }

  getSearchFetch() async {
    var data = await FirebaseFirestore.instance
        .collection('WallpaperInfo')
        .orderBy('craeteat', descending: true)
        .get();

    setState(() {
      Results = data.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black, size: 30),
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Paper',
          style: TextStyle(color: Colors.lightBlue[400], fontSize: 30),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WallpaperPublicPage(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.photo,
          color: Colors.lightBlue[400],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 5),
                ],
              ),
              child: TextFormField(
                autofocus: false,
                onTap: () {
                  if (isShowPost == true) {
                    setState(() {
                      isShowPost = false;
                    });
                  }
                },
                onFieldSubmitted: (value) {
                  _onsearch();
                },
                controller: searchController,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    isDense: true,
                    suffixIconColor: Colors.grey[600],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    hintText: "Exploar Wallpaper",
                    hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
          ),
          isShowPost
              ? getResult.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text('Wallpaper not found!'),
                      ),
                    )
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: getResult.length,
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: (1 / 1.5),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemBuilder: (context, index) {
                            return WallpaperCard(
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              description: getResult[index]['description'],
                              PostId: getResult[index].id,
                              title: getResult[index]["title"],
                              img: getResult[index]["img"],
                              username: getResult[index]['username'],
                              createAt: timeago.format(
                                  getResult[index]['craeteat'].toDate()),
                              favorite: List<String>.from(
                                getResult[index]["PostFavorite"] ?? [],
                              ),
                            );
                          },
                        ),
                      ),
                    )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: StreamBuilder(
                      stream: postsStream,
                      builder: (context, snapshot) {
                        var data = snapshot.data?.docs;
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.none) {
                          return const Center(
                            child: Text('Check Connection...'),
                          );
                        }
                        if (snapshot.hasData) {
                          return GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: data!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (1 / 1.5),
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemBuilder: (context, index) {
                              return WallpaperCard(
                                uid: FirebaseAuth.instance.currentUser!.uid,
                                description: data[index]['description'],
                                PostId: data[index].id,
                                title: data[index]['title'],
                                img: data[index]["img"],
                                username: data[index]['username'],
                                createAt: timeago
                                    .format(data[index]['craeteat'].toDate()),
                                favorite: List<String>.from(
                                  data[index]["PostFavorite"] ?? [],
                                ),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
