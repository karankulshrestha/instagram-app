import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/models/user.dart' as model;
import 'package:instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = await _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //sign up a user
  Future<String> signupUser(
      {required String username,
      required String email,
      required String password,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register the user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String profileURI = await StorageMethods()
            .uploadImageToFirebase('profilePics', file, false);

        // add user to database
        model.User user = model.User(
          email: email,
          uid: cred.user!.uid,
          photoUrl: profileURI,
          username: username,
          bio: bio,
          followers: [],
          following: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "Success";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'email or password is required';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
