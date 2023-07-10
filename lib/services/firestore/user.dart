import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logbook2electricboogaloo/services/firestore/sharing.dart';

// User Data Service File

// User Data Type
class UserData {
  final String uid;

  late String pid;
  late String email;
  late String firstname;
  late String lastname;
  late String? avatar;
  late List<String> activities;

  UserData({required this.uid, data}) {
    email = data?['Email'] ?? "";
    firstname = data?['Firstname'] ?? "";
    lastname = data?['Lastname'] ?? "";
    avatar = data?['Avatar'];
    activities = List<String>.from(data?['Activities'] ?? []);
    pid = data?['pid'] ?? "";
  }
}

String primaryUID = "";

final CollectionReference _userRef =
    FirebaseFirestore.instance.collection('users');

// User Data Stream
Stream<UserData> get userStream {
  return _userRef.doc(primaryUID).snapshots().map(_convert2UserData);
}

// Converts a Document Snapshot to a UserData
UserData _convert2UserData(DocumentSnapshot<Object?>? documentSnapshot) {
  if (documentSnapshot == null) {
    return UserData(uid: primaryUID);
  } else {
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    return UserData(uid: primaryUID, data: data);
  }
}

// Creates User in Users Collection
Future createUser({String? email, String? firstname, String? lastname}) async {
  await _userRef.doc(primaryUID).set({
    'Email': email,
    'Firstname': firstname,
    'Lastname': lastname,
    'Activities': [],
    'pid': await createPublicEntry()
  });
}

// Updates field of User document
Future updateUser(k, v) async {
  await _userRef.doc(primaryUID).update({k: v});
}
