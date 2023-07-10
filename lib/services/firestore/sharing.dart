import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jumping_dot/jumping_dot.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';

// Public User Data File

final CollectionReference _userRef =
    FirebaseFirestore.instance.collection('users');

final CollectionReference _publicRef =
    FirebaseFirestore.instance.collection('public');

Future<Map> getPublicFields(String pid, List<String> requestedFields) async {
  DocumentSnapshot sharingData = await _publicRef.doc(pid).get();
  DocumentSnapshot requestedUser =
      await _userRef.doc(sharingData.get("uid")).get();
  List publicFields = sharingData.get("publicfields");
  requestedFields.removeWhere((element) => !publicFields.contains(element));

  Map output = {};
  requestedFields.forEach((element) async {
    try {
      output[element] = requestedUser.get(element);
    } catch (e) {
      print("Error : (Probably incorrect field) $e");
    }
  });
  return output;
}

Future<String> createPublicEntry() async {
  return (await _publicRef.add({
    "uid": primaryUID,
    "publicfields": ["Firstname"]
  }))
      .id;
}

// Create User field builder

Widget sharedUser(String pid) {
  return FutureBuilder<Map>(
      future: getPublicFields(pid, ["Firstname", "Lastname"]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String firstname = snapshot.data!['Firstname'] is String
              ? snapshot.data!['Firstname']
              : 'Anonymous';
          String lastname = snapshot.data!['Lastname'] is String
              ? snapshot.data!['Lastname']
              : '';
          return Text("$firstname $lastname");
        } else {
          return JumpingDots(
              color: Theme.of(context).colorScheme.secondary, radius: 5);
        }
      });
}
