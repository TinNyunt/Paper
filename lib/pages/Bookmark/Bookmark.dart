import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:paper/pages/Bookmark/LibraryCard.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
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
            "Your Library",
            style: TextStyle(color: Colors.lightBlue[400], fontSize: 30),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelColor: Colors.lightBlue[300],
                indicatorColor: const Color.fromARGB(0, 255, 255, 255),
                isScrollable: true,
                labelStyle: const TextStyle(fontSize: 18),
                labelPadding: const EdgeInsets.only(left: 20, right: 0),
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'All',
                  ),
                  Tab(
                    text: 'Your Save',
                  ),
                  Tab(
                    text: 'Your Favorite',
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          physics: const BouncingScrollPhysics(),
          children: [
            // 1
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Library')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection('Items')
                  .where(
                    'uid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
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
                      'No Library..',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return MasonryGridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibraryCard(
                        uid: data[index]['uid'],
                        id: data[index].id,
                        img: data[index]['image'],
                      ),
                    );
                  },
                );
              },
            ),
            // 2
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Library')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection('Items')
                  .where('category', isEqualTo: "default")
                  .where(
                    'uid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
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
                      'No Library..',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                return MasonryGridView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: data.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibraryCard(
                        uid: data[index]['uid'],
                        id: data[index].id,
                        img: data[index]['image'],
                      ),
                    );
                  },
                );
              },
            ),
            // 3
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Library')
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection('Items')
                  .where('category', isEqualTo: "favorite")
                  .where(
                    'uid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                  )
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
                      'No Library..',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return MasonryGridView.builder(
                  itemCount: data.length,
                  gridDelegate:
                      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: LibraryCard(
                        uid: data[index]['uid'],
                        id: data[index].id,
                        img: data[index]['image'],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
