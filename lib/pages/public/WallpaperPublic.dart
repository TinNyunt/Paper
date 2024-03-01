// ignore_for_file: use_build_context_synchronously, unnecessary_new, unrelated_type_equality_checks

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paper/services/post.dart';
import 'package:paper/widgets/RoutePage.dart';

class WallpaperPublicPage extends StatefulWidget {
  const WallpaperPublicPage({super.key});

  @override
  State<WallpaperPublicPage> createState() => _WallpaperPublicPageState();
}

class _WallpaperPublicPageState extends State<WallpaperPublicPage> {
  File? postImage;
  final picker = ImagePicker();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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

  void AddWallpaper(context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Wrap(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'Choose Photo',
                  style: TextStyle(fontSize: 26, color: Colors.black),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo,
                  color: Colors.black,
                ),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickfile =
                      await picker.pickImage(source: ImageSource.gallery);

                  setState(
                    () {
                      if (pickfile != null) {
                        postImage = File(pickfile.path) as File?;
                      } else {
                        print("Select User Image");
                      }
                    },
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickfile =
                      await picker.pickImage(source: ImageSource.camera);

                  setState(
                    () {
                      if (pickfile != null) {
                        postImage = File(pickfile.path) as File?;
                      } else {
                        print("Select User Image");
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      AddWallpaper(context);
    });
  }

  PublicWallpaper() async {
    if (postImage != null &&
        titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      await WallpaperPost().PostWallpaper(
        titleController.text,
        postImage!,
        descriptionController.text,
        categoryChip,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoutePage(),
        ),
      );
    } else {
      var snackBar = SnackBar(
        content: const Text('No image or No title or No Description'),
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.all(20),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 10,
          left: 10,
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RoutePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: PublicWallpaper,
            label: const Text(
              'Public',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            icon: const Icon(
              Icons.public,
              color: Colors.black,
              size: 20,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                postImage != null
                    ? GestureDetector(
                        onTap: () => AddWallpaper(context),
                        child: Container(
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              postImage!,
                              fit: BoxFit.cover,
                              height: 240,
                            ),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () => AddWallpaper(context),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const Image(
                            height: 300,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            image: AssetImage('images/NoImage.jpg'),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Title';
                      }
                      return null;
                    },
                    decoration: const InputDecoration.collapsed(
                      hintText: "Title",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Description';
                      }
                      return null;
                    },
                    maxLines: 3,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: List<Widget>.generate(
                    _options.length,
                    (int index) {
                      return ChoiceChip(
                        label: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(_options[index]),
                        ),
                        backgroundColor: Colors.white,
                        elevation: 0.5,
                        selectedColor: Colors.black,
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
                            print(categoryChip);
                          });
                        },
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
