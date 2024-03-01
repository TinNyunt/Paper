// ignore_for_file: non_constant_identifier_names, avoid_print
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  int random(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  Future<void> RegisterAccount(String Email, String Password) async {
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
      await result.user?.updateDisplayName('User_${random(100, 900)}');

      firestore
          .collection("User")
          .doc(result.user?.uid)
          .set(
            {
              'username': auth.currentUser!.displayName,
              'email': Email,
              'uid': result.user?.uid,
              'userimg':
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRrS17qvXTUKG6mZfouOKvWXL6Sl6e88-wwA&usqp=CAU',
            },
          )
          .then((value) => print("User Added"))
          .catchError(
            (error) => print("Failed to add user: $error"),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> LoginAccount(String Email, String Password) async {
    try {
      // This will Log in the existing user in our firebase
      await auth.signInWithEmailAndPassword(
        email: Email,
        password: Password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }
}
