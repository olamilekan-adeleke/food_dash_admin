import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../../cores/constants/error_text.dart';
import '../../../cores/utils/firebase_messaging_utils.dart';
import '../../../cores/utils/logger.dart';
import '../../../features/auth/model/login_user_model.dart';
import '../../../features/auth/model/user_details_model.dart';
import '../../../features/food/repo/local_database_repo.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

class AuthenticationRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final LocaldatabaseRepo localdatabaseRepo =
      GetIt.instance<LocaldatabaseRepo>();
  final CollectionReference<dynamic> adminCollectionRef =
      FirebaseFirestore.instance.collection('admin');

  LoginUserModel? userFromFirestore(User? user) {
    infoLog(
      'User: ${user?.uid}',
      message: 'attemping to get user auth state',
      title: 'auth state',
    );
    return user != null ? LoginUserModel(user.uid) : null;
  }

  String? getUserUid() {
    return _firebaseAuth.currentUser?.uid;
  }

  Stream<LoginUserModel?> get userAuthState {
    /// emit a stream of user current state(e.g emit an event when the user
    /// log out so the UI can be notify and update as needed or emit a event
    ///  when a user log in so the UI can also be updated

    return _firebaseAuth.authStateChanges().map((User? user) {
      log(user.toString());
      return userFromFirestore(user);
    });
  }

  Future<void> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      if (await isUserExist(email) == true) {
        throw 'User does not exist!';
      }

      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // _firebaseAuth.currentUser!

      final User? user = userCredential.user;
      infoLog('userCredential: ${user?.uid}', title: 'user log in');

      final Map<String, dynamic> userData = await getLoggedInUser(email);
      userData.remove('date_joined');
      await localdatabaseRepo.saveUserDataToLocalDB(userData);
      await NotificationMethods.subscribeToTopice(user!.uid);
      await NotificationMethods.subscribeToTopice('riders');
    } on SocketException {
      throw Exception(noInternetConnectionText);
    } catch (e, s) {
      errorLog(
        e.toString(),
        'Error loging in user',
        title: 'login',
        trace: s.toString(),
      );
      throw Exception(e.toString());
    }
  }

  Future<bool> authenticateUser(String password) async {
    bool authenticated = false;
    final String email =
        (await localdatabaseRepo.getUserDataFromLocalDB())!.email;

    final UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    if (userCredential.user != null) {
      authenticated = true;
    }

    return authenticated;
  }

  Future<void> registerUserWithEmailAndPassword({
    required String email,
    required String password,
    required String dob,
    required String fullName,
    required int number,
  }) async {
    try {
      //sign up user with email and password
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      // if for what ever reason the user object is null, then just return
      //an exception
      if (user == null) throw Exception('Opps, an error occured!');

      final RiderDetailsModel userDetailsModel = RiderDetailsModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        walletBalance: 0.0,
        phoneNumber: number,
        dateJoined: Timestamp.now(),
        dob: dob,
      );

      infoLog('userCredential: ${user.uid}', title: 'user sign up');

      // save user data to database
      await addUserDataToFirestore(userDetailsModel);

      //subscribe user to notifications.
      await NotificationMethods.subscribeToTopice(user.uid);

      final RiderDetailsModel userDetailsForLocalDb = RiderDetailsModel(
        uid: user.uid,
        email: email,
        fullName: fullName,
        phoneNumber: number,
        walletBalance: 0.0,
        dob: dob,
      );

      await localdatabaseRepo
          .saveUserDataToLocalDB(userDetailsForLocalDb.toMap());
    } catch (e, s) {
      errorLog(
        e.toString(),
        'Error siging up in user',
        title: 'sign up',
        trace: s.toString(),
      );
      throw Exception(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      infoLog('user email: $email', title: 'reset password');
    } catch (e, s) {
      errorLog(
        e.toString(),
        'Error reset password',
        title: 'reset password',
        trace: s.toString(),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      Get.back();
      infoLog('user loging out', title: 'log out');
    } catch (e, s) {
      errorLog(
        e.toString(),
        'Error log out',
        title: 'log out',
        trace: s.toString(),
      );
      throw Exception('Error: $e');
    }
  }

  Future<void> addUserDataToFirestore(RiderDetailsModel userDetails) async {
    await adminCollectionRef
        .doc(userDetails.uid)
        .set(userDetails.toMapForLocalDb());
    infoLog('Added User database', title: 'Add user data To Db');
  }

  Future<void> updateUserData(RiderDetailsModel userDetails) async {
    try {
      await adminCollectionRef.doc(userDetails.uid).update(userDetails.toMap());
      await localdatabaseRepo.saveUserDataToLocalDB(userDetails.toMap());
      infoLog('Upadted User database', title: 'Upadted user data To Db');
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> getLoggedInUser(String email) async {
    final QuerySnapshot<dynamic> querySnapshot =
        await adminCollectionRef.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isEmpty) {
      await signOut();
      throw 'No user found!';
    }

    final DocumentSnapshot<dynamic> documentSnapshot = querySnapshot.docs.first;

    return documentSnapshot.data() as Map<String, dynamic>;
  }

  Future<bool> isUserExist(String email) async {
    final QuerySnapshot<dynamic> querySnapshot =
        await adminCollectionRef.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      return false;
    }

    return true;
  }
}
