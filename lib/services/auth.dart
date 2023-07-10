import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/local.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthService();

  // User Stream
  Stream<String?> get uidStream {
    return _auth.authStateChanges().map((event) => event?.uid);
  }

  // Check Email user exists
  Future<bool> emailUserExists(String email) async {
    try {
      final list = await _auth.fetchSignInMethodsForEmail(email);

      if (list.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  // Sign in with Email
  Future<bool> signInEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  // Register with Email
  Future registerEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      primaryUID = result.user!.uid;
      createUser(email: result.user!.email);
      result.user?.sendEmailVerification();
      return result.user?.uid;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Reset Password
  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    clearAllLocal();
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }
}
