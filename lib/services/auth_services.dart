import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> signIn(String email, String password) async {
    try {
      final UserCredential signIn = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _firebaseFirestore.collection('users').doc(signIn.user!.uid).set(
          {'uid': signIn.user!.uid, 'email': email}, SetOptions(merge: true));
      return signIn;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // add new users
  Future<UserCredential> createAccount(String email, String password) async {
    try {
      final UserCredential user = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firebaseFirestore
          .collection('users')
          .doc(user.user!.uid)
          .set({'uid': user.user!.uid, 'email': email});
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign Out Method
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
