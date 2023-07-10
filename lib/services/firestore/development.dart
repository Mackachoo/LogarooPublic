import 'package:cloud_firestore/cloud_firestore.dart';

// Development Service File

// Development References
final CollectionReference _devRef =
    FirebaseFirestore.instance.collection('development');

// Check permission level of user
Future<int> permissionLevel(String uid) async {
  DocumentSnapshot permssions = await _devRef.doc("Permissions").get();
  if ((permssions.data() as Map).containsKey(uid)) {
    return permssions.get(uid);
  } else {
    return -1;
  }
}
