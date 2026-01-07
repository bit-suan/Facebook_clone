import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_clone/core/constants/firebaes_collection_names.dart';
import 'package:flutter/foundation.dart';
import 'package:facebook_clone/core/constants/storage_folder_names.dart';
import 'package:facebook_clone/core/utils/utils.dart';
import 'package:facebook_clone/features/auth/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:facebook_clone/core/constants/constants.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  // sign in
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Ensure user document exists in Firestore
        final userDoc = await _firestore
            .collection(FirebaseCollectionNames.users)
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Create a recovery profile
          UserModel userModel = UserModel(
            fullName: user.displayName ?? 'New User',
            birthDay: DateTime(2000),
            gender: 'Not Specified',
            email: email,
            password: password,
            profilePicUrl: user.photoURL ?? Constants.maleProfilePic,
            uid: user.uid,
            friends: const [],
            sentRequests: const [],
            receivedRequests: const [],
          );

          await _firestore
              .collection(FirebaseCollectionNames.users)
              .doc(user.uid)
              .set(userModel.toMap());
        }
      }

      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  // Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // NOTE: For Web, you MUST provide a clientId. 
      // You can find this in your Firebase Console under Project Settings > General > Web Apps.
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId: kIsWeb ? '637630116118-ndses6bs6fkmbfbe1kpmgq5e14cbf26s.apps.googleusercontent.com' : null,
      ).signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        // Check if user already exists in Firestore
        final userDoc = await _firestore
            .collection(FirebaseCollectionNames.users)
            .doc(user.uid)
            .get();

        if (!userDoc.exists) {
          // Save new user to firestore
          UserModel userModel = UserModel(
            fullName: user.displayName ?? 'No Name',
            birthDay: DateTime(2000), // Default placeholder
            gender: 'Not Specified', // Default placeholder
            email: user.email ?? '',
            password: '', // Social login doesn't use password
            profilePicUrl: user.photoURL ?? Constants.maleProfilePic,
            uid: user.uid,
            friends: const [],
            sentRequests: const [],
            receivedRequests: const [],
          );

          await _firestore
              .collection(FirebaseCollectionNames.users)
              .doc(user.uid)
              .set(userModel.toMap());
        }
      }

      return userCredential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  // sign out
  Future<String?> signOut() async {
    try {
      _auth.signOut();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // create account
  Future<UserCredential?> createAccount({
    required String fullName,
    required DateTime birthday,
    required String gender,
    required String email,
    required String password,
    Uint8List? imageBytes, // Changed to Uint8List for Web compatibility
  }) async {
    try {
      // create an account in firebase
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;
      String downloadUrl = Constants.maleProfilePic;

      // Save image to firebase storage if provided
      if (imageBytes != null) {
        final path = _storage
            .ref(StorageFolderNames.profilePics)
            .child(uid);
        
        final taskSnapshot = await path.putData(imageBytes);
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
      }

      UserModel user = UserModel(
        fullName: fullName,
        birthDay: birthday,
        gender: gender,
        email: email,
        password: password,
        profilePicUrl: downloadUrl,
        uid: uid,
        friends: const [],
        sentRequests: const [],
        receivedRequests: const [],
      );

      // save user to firestore
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(uid)
          .set(
            user.toMap(),
          );

      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  // Verify Email
  Future<String?> verifyEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      if (user != null) {
        user.sendEmailVerification();
      }
      return null;
    } catch (e) {
      showToastMessage(text: e.toString());
      return e.toString();
    }
  }

  // get user info
  Future<UserModel> getUserInfo() async {
    final userData = await _firestore
        .collection(FirebaseCollectionNames.users)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final user = UserModel.fromMap(userData.data()!);
    return user;
  }
}
