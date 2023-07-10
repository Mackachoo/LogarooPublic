import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/logs.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/card.dart';
import 'package:logbook2electricboogaloo/widgets/logbook/parameters.dart'
    as parameters;

class LogGrid extends StatelessWidget {
  final UserData user;
  final Activity activity;
  const LogGrid({super.key, required this.user, required this.activity});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map>>(
        stream: logStream(activity),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.spaceEvenly,
              // clipBehavior: Clip.none,
              // itemCount: (snapshot.data?.docs.length ?? 0) + 1,
              children: () {
                List<Log> logs = [];

                // Collects Logs from Database, throwing meta data
                for (QueryDocumentSnapshot<Map>? log in snapshot.data!.docs) {
                  if (log != null && !log.id.startsWith('_')) {
                    Log thisLog = Log(
                        name: log.id, data: log.data() as Map<String, dynamic>);
                    logs.add(thisLog);
                  }
                }

                if (parameters.filter.isNotEmpty) {}

                if (parameters.group.isNotEmpty) {}

                // Deleted logs filter
                logs.removeWhere((e) => e.deleted != parameters.deleted);

                if (parameters.search != null) {}

                if (parameters.sort != null) {
                  // logs.sort((a, b) => a.data!['Date'])
                }

                // Turns list of logs into a list of LogCards
                return logs
                    .map((e) => LogCard(
                          log: e,
                          uid: user.uid,
                          activity: activity,
                        ))
                    .toList();
              }(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
