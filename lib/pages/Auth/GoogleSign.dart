import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:paper/Button/GoogleButton.dart';
import 'package:paper/widgets/RoutePage.dart';

class GoogleSign extends StatefulWidget {
  const GoogleSign({super.key});

  @override
  State<GoogleSign> createState() => _GoogleSignState();
}

class _GoogleSignState extends State<GoogleSign> {
  googleSign() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);

    FirebaseFirestore.instance.collection("User").doc(result.user?.uid).set(
      {
        'username': result.user!.displayName,
        'email': result.user!.email,
        'uid': result.user?.uid,
        'userimg': result.user?.photoURL
      },
    ).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoutePage(),
        ),
      );
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                child: Image(
                  width: 100,
                  height: 100,
                  image: AssetImage("images/Icon.png"),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Paper",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Wallpaper Application",
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
          GoogleButton(
            title: "Google Account",
            onTap: googleSign,
            width: 350,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
