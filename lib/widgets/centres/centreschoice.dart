import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';
import 'package:logbook2electricboogaloo/services/local.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';

class CentreChoice extends StatelessWidget {
  final UserData user;
  final Activity activity;
  const CentreChoice({super.key, required this.user, required this.activity});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Centre>>(
      future: getCentres(activity),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!
                .map((centre) => AssetButton(
                    label: centre.name,
                    asset: const Icon(Icons.donut_large),
                    onPressed: () async {
                      if (!centre.users.containsKey(user.pid)) {
                        updateCentreMap(
                            'Users', {user.pid: centre.lowestRole()},
                            cid: centre.cid);
                      }
                      storeLocal("previousCentre", centre.cid);
                      Navigator.of(context).pop(centre.cid);
                    }))
                .toList(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
