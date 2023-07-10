import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/roles.dart';

// Centre Service File

// Centre Type
class Centre {
  final String cid;

  late String name;
  late List<String> activities;
  late Future<List<Role>> roles;
  late Map<String, dynamic> users;
  late GeoPoint location;
  late bool visible;

  Centre(
      {required this.cid,
      String? name,
      Map? data,
      List? activities,
      GeoPoint? location,
      bool? visible,
      Future<List<Role>>? roles,
      Map<String, dynamic>? users}) {
    if (data != null) {
      name = data['Name'];
      activities = data['Activities'];
      location = data['Location'];
      visible = data['Visible'];
      users = data['Users'];
    }
    this.name = name ?? "";
    this.activities = List<String>.from(activities ?? []);
    this.location = location ?? const GeoPoint(0, 0);
    this.visible = visible ?? false;
    this.roles = roles ?? Future(() => []);
    this.users = users ?? {};
  }

  Future<Role?> lowestRole() async {
    Role? lowest;
    int rank = 0;
    for (var role in (await roles)) {
      if (role.rank > rank) {
        lowest = role;
        rank = role.rank;
      }
    }
    return lowest;
  }
}

// String primaryCID = "";

// Collection References
final CollectionReference _centreRef =
    FirebaseFirestore.instance.collection('centres');

// Gets list of Centres
Future<List<Centre>> getCentres(Activity activity) async {
  List<DocumentSnapshot> centreDocs = (await _centreRef.get()).docs;
  List<Centre> outputCentres = [];
  for (DocumentSnapshot dD in centreDocs) {
    outputCentres.add(Centre(
        cid: dD.id,
        name: dD.get("Name"),
        activities: dD.get("Activities"),
        location: dD.get("Location"),
        users: dD.get("Users")));
  }

  return outputCentres
      .where((centre) => centre.activities.contains(activity.name))
      .toList();
}

// Centre Stream
Stream<Centre?> centreStream(String cid) {
  return _centreRef.doc(cid).snapshots().map(_convert2Centre);
}

Centre? _convert2Centre(DocumentSnapshot<Object?>? documentSnapshot) {
  if (documentSnapshot == null) {
    return null;
  } else {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return Centre(
        cid: documentSnapshot.id,
        data: data,
        roles: getCentreRoles(documentSnapshot.id));
  }
}

// Creates Centre in Users Collection
Future<String> createCentre({String? name, String? activity}) async {
  String cid = (await _centreRef.add({
    'Name': name ?? "???",
    'Activities': [activity],
    'Roles': {
      "Owner": [0, '*'],
      "Public": [1]
    },
    'Users': {},
    'Visible': false,
    'Location': const GeoPoint(0, 0)
  }))
      .id;

  return cid;
}

// Gets List of roles the centre has
Future<List<Role>> getCentreRoles(String cid) async {
  List<DocumentSnapshot> roleDocs =
      (await _centreRef.doc(cid).collection("_roles").get()).docs;
  List<Role> outputRoles = [];
  for (DocumentSnapshot dD in roleDocs) {
    outputRoles.add(Role(
        name: dD.id,
        rank: dD.get("rank"),
        permissions: List<String>.from(dD.get("permissions"))));
  }

  return outputRoles;
}

// Updates field of Centre document
Future updateCentre(String k, dynamic v, {required String cid}) async {
  await _centreRef.doc(cid).update({k: v});
}

// Updates map field of Centre document
Future updateCentreMap(String k, Map v, {required String cid}) async {
  await _centreRef.doc(cid).set({k: v}, SetOptions(merge: true));
}
