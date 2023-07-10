import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';

// Log Service File

// Log Type
class Log {
  final String name;
  final Map<String, dynamic>? data;

  Map<String, Map<String, dynamic>> fields = {};
  late int visibleRows;
  late bool deleted;
  List<int> layout = [];

  Log(
      {required this.name,
      this.data,
      Map<String, dynamic>? fields,
      int? visibleRows,
      bool? deleted}) {
    // Gets template meta data
    this.visibleRows = visibleRows ?? (data?["_visibleRows"] ?? 0);
    this.deleted = deleted ?? (data?["_deleted"] ?? false);
    data!.removeWhere((k, v) => k.contains('_'));

    // Gets template fields
    if (fields != null) {
      this.fields = fields.cast<String, Map<String, dynamic>>();
    } else if (data != null) {
      this.fields = data!.cast<String, Map<String, dynamic>>();
    }

    for (dynamic fieldData in this.fields.values) {
      List pos = fieldData['position'];
      while (layout.length <= pos[0]) {
        layout.add(0);
      }
      layout[pos[0]] += 1;
    }
  }

  Map<String, dynamic> toDocMap() {
    Map<String, dynamic> docMap = {};
    docMap.addAll(fields);
    docMap["_visibleRows"] = visibleRows;
    return docMap;
  }
}

final CollectionReference _userRef =
    FirebaseFirestore.instance.collection('users');

// Log Stream
Stream<QuerySnapshot<Map<String, dynamic>>> logStream(Activity activity) {
  return _userRef.doc(primaryUID).collection(activity.name).snapshots();
}

// Gets the user templates for a given Activity
Future<List<Log>> getTemplates(Activity activity) async {
  List<Log> templates = [];

  DocumentSnapshot<Map<String, dynamic>> doc = await _userRef
      .doc(primaryUID)
      .collection(activity.name)
      .doc("_templates")
      .get();

  doc.data()?.forEach((name, value) {
    templates.add(Log(name: name, data: value));
  });
  return templates;
}

// Updates a user log
Future updateLog(
    {required Activity activity,
    required Log log,
    required String name,
    required dynamic value}) async {
  await _userRef
      .doc(primaryUID)
      .collection(activity.name)
      .doc(log.name)
      .update({name: value});
}

// Delete a user log
Future deleteLog({required Activity activity, required Log log}) async {
  await _userRef
      .doc(primaryUID)
      .collection(activity.name)
      .doc(log.name)
      .delete();
}

// Adds an empty log to the
Future addLog({required Activity activity, required Log template}) async {
  await _userRef
      .doc(primaryUID)
      .collection(activity.name)
      .add(template.toDocMap());
}
