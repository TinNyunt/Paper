// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paper/Button/mybutton.dart';
import 'package:paper/pages/Auth/LoginPage.dart';
import 'package:paper/pages/Setting/SettingPage.dart';
import 'package:paper/widgets/ImageView.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../Button/Bottomsheetbutton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var User = {};
  bool isLoading = false;

  FetchUser() async {
    setState(() {
      isLoading = true;
    });

    var userdata = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {});
    User = userdata.data()!;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    FetchUser();
  }

  LogoutAccount() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  UserDataCheck(id) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          titlePadding: EdgeInsets.zero,
          title: const Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 0, 0),
            child: Text('Yours Wallpaper'),
          ),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Delete',
                style: TextStyle(fontSize: 18),
              ),
              onPressed: () async {},
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Profile",
          style: TextStyle(color: Colors.lightBlue[400], fontSize: 30),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // background image and bottom contents
                  Column(
                    children: [
                      Container(
                        height: 100.0,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[200],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 55,
                            ),
                            Text(
                              User['username'],
                              style: const TextStyle(fontSize: 25),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              User['email'],
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyButton(
                                  title: 'Logout',
                                  onTap: LogoutAccount,
                                  width: 150,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                MyButton(
                                  title: 'Setting',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingPage(),
                                      ),
                                    );
                                  },
                                  width: 150,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Your Photo',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // data
                            Expanded(
                              child: FutureBuilder(
                                future: FirebaseFirestore.instance
                                    .collection('WallpaperInfo')
                                    .where('uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1 / 1.5,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 1.5,
                                      ),
                                      itemBuilder: (context, index) {
                                        String id =
                                            snapshot.data!.docs[index].id;
                                        DocumentSnapshot snap =
                                            snapshot.data!.docs[index];
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onLongPress: () {
                                                showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (BuildContext bc) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      margin:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: Wrap(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20,
                                                                    10,
                                                                    0,
                                                                    10),
                                                            child: Text(
                                                              (snap.data()
                                                                      as dynamic)[
                                                                  'title'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                            ),
                                                          ),
                                                          Divider(),
                                                          BottomSheetButton(
                                                            title:
                                                                "Change Private",
                                                            onTap: () {},
                                                            width:
                                                                double.infinity,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          BottomSheetButton(
                                                            title:
                                                                "Delete Wallpaper",
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'WallpaperInfo')
                                                                  .doc(id)
                                                                  .delete();
                                                              FirebaseStorage
                                                                  .instance
                                                                  .refFromURL((snap
                                                                          .data()
                                                                      as dynamic)['img'])
                                                                  .delete();

                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'Library')
                                                                  .doc(FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .email)
                                                                  .collection(
                                                                      'Items')
                                                                  .doc(id)
                                                                  .delete();
                                                            },
                                                            width:
                                                                double.infinity,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ImageView(
                                                      img: (snap.data()
                                                          as dynamic)['img'],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: (snap.data()
                                                      as dynamic)['img'],
                                                  imageBuilder: (context,
                                                      imageProvioder) {
                                                    return Image(
                                                      height: 250,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                      image: imageProvioder,
                                                    );
                                                  },
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (snap.data() as dynamic)['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  // Profile image
                  Positioned(
                    top:
                        45.0, // (background container size) - (circle height / 2)
                    child: GestureDetector(
                      onTap: () => _ProfileEdit(context),
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        child: CachedNetworkImage(
                          imageUrl: User['userimg'],
                          imageBuilder: (context, imageProvioder) {
                            return CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: imageProvioder,
                            );
                          },
                          placeholder: (context, url) => const SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  File? userimage;
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;

  PickProfileImage() async {
    final pickfile = await picker.pickImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickfile != null) {
          userimage = File(pickfile.path) as File?;
        } else {
          print("Select User Image");
        }
      },
    );
  }

  SaveProfileImage() async {
    var storageRef = storage
        .ref()
        .child('UserImage/${FirebaseAuth.instance.currentUser?.displayName}/0');
    var uploadTask = storageRef.putFile(
        userimage!, SettableMetadata(contentType: 'image/png'));
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();

    FirebaseAuth.instance.currentUser?.updatePhotoURL(downloadUrl.toString());

    FirebaseFirestore.instance
        .collection("User")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        "userimg": downloadUrl.toString(),
      },
    );
  }

  _ProfileEdit(context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          margin: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Change Profile',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        BottomSheetButton(
                          title: "Update",
                          onTap: SaveProfileImage,
                          width: 90,
                          color: Colors.grey.shade300.withOpacity(.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  userimage != null
                      ? GestureDetector(
                          onTap: PickProfileImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: Image.file(
                              userimage as File,
                              fit: BoxFit.cover,
                            ).image,
                          ),
                        )
                      : GestureDetector(
                          onTap: PickProfileImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(User['userimg']),
                          ),
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
