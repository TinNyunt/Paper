import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paper/Button/Bottomsheetbutton.dart';
import 'package:paper/Button/SettingButton.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List setting = [
    'Delete Account',
    'Support',
    'About',
    "Logout",
  ];

  DeleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Delete Account",
          style: TextStyle(fontSize: 20),
        ),
        content: const Text("You want to delete account!"),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BottomSheetButton(
                title: "No",
                onTap: () {
                  Navigator.pop(context);
                },
                width: 100,
                color: Colors.grey.shade200.withOpacity(.5),
              ),
              const SizedBox(
                width: 20,
              ),
              BottomSheetButton(
                title: "Yes",
                onTap: () {
                  FirebaseAuth.instance.currentUser!.delete();
                  FirebaseFirestore.instance
                      .collection('User')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .delete();
                  Navigator.pop(context);
                },
                width: 100,
                color: Colors.grey.shade200.withOpacity(.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        titleSpacing: 0,
        title: const Text(
          'Setting',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: setting.length,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingButton(
                    onTap: () {
                      if (setting[0] == setting[index]) {
                        DeleteAccount();
                      } else if (setting[1] == setting[index]) {
                        print('Support');
                      } else if (setting[2] == setting[index]) {
                        print('About');
                      } else if (setting[3] == setting[index]) {
                        FirebaseAuth.instance.signOut();
                        GoogleSignIn().signOut();
                        Navigator.pop(context);
                      }
                    },
                    title: setting[index],
                    color: setting[0] == setting[index]
                        ? Colors.red.shade600
                        : Colors.grey.shade200.withOpacity(.5),
                    textcolor: setting[0] == setting[index]
                        ? Colors.white
                        : Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          )),
    );
  }
}
