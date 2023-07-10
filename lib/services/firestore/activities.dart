import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';

// Activity Service File

class Activity {
  final String name;
  final Map<String, dynamic>? data;

  late String icon;
  late String source;
  late String centre;
  Activity({required this.name, this.data, icon, source, centre}) {
    this.icon = data?['icon'] ?? (icon ?? "activity");
    this.source = data?['source'] ?? (source ?? "user");
    this.centre = data?['centre'] ?? (centre ?? "Centre");
  }

  Map<String, dynamic> toMap() {
    return {"name": name, "icon": icon, "source": source, "centre": centre};
  }

  @override
  String toString() {
    return toMap().toString();
  }
}

// Collection References
final CollectionReference _userRef =
    FirebaseFirestore.instance.collection('users');

final CollectionReference _defaultRef =
    FirebaseFirestore.instance.collection('defaults');

// Gets list of default activities
Future<List<Activity>> getDefaultActivities() async {
  List<Activity> defaultActivities = [];
  for (DocumentSnapshot dD in (await _defaultRef.get()).docs) {
    defaultActivities.add(Activity(
        name: dD.id,
        icon: dD.get("icon"),
        source: dD.get("source"),
        centre: dD.get("centre")));
  }
  return defaultActivities;
}

// Gets the Activities a user has access to
Future<List<Activity>> getActivities() async {
  List userActivityNames =
      (await _userRef.doc(primaryUID).get()).get("Activities");
  List<Activity> userActivities = [];
  for (String uA in userActivityNames) {
    Map<String, dynamic>? data =
        (await _userRef.doc(primaryUID).collection(uA).doc("_data").get())
            .data();
    if (kDebugMode && data == null) {
      print(
          "Activity Retrieval Error (Possibly Collection 'Activities' field mismatch)");
    }
    userActivities.add(Activity(name: uA, data: data));
  }

  return (await getDefaultActivities())
          .where((defaults) =>
              userActivities.every((users) => users.name != defaults.name))
          .toList() +
      userActivities;
}

// Adds activity a user subcollection
Future addActivity(Activity activity) async {
  updateUser('Activities', FieldValue.arrayUnion([activity.name]));
  await _userRef.doc(primaryUID).collection(activity.name).doc("_data").set({
    "icon": activity.icon,
    "source": activity.source.contains("Default") ? "fromDefault" : "user"
  });
  if (activity.source == "isDefault") {
    Map<String, dynamic> templates =
        (await _defaultRef.doc(activity.name).get()).get("templates");
    await _userRef
        .doc(primaryUID)
        .collection(activity.name)
        .doc("_templates")
        .set(templates);
  }
}
