import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/firestore/development.dart';
import 'package:logbook2electricboogaloo/widgets/buttons.dart';
import 'package:logbook2electricboogaloo/widgets/dialogs.dart';

class CreateCentreButton extends StatelessWidget {
  final String uid;
  final Activity activity;
  const CreateCentreButton(
      {super.key, required this.uid, required this.activity});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: permissionLevel(uid),
        builder: (context, snapshot) => snapshot.data == 0
            ? IconButton(
                onPressed: () => popup(
                    context: context,
                    title: Text("Add new ${activity.centre}"),
                    child: centreSlide(context)),
                icon: Icon(Icons.new_label_outlined))
            : const SizedBox(width: 60));
  }

  Widget centreSlide(BuildContext context) {
    return ConstrainedBox(
      constraints:
          const BoxConstraints(minWidth: 300, maxWidth: 400, maxHeight: 80),
      child: SlideButton(
        label: "Slide to create",
        // action: () => createCentre(
        //   activity: activity.name,
        // ),
        action: () async {
          String cid = await createCentre(activity: activity.name);
          Navigator.of(context).pop();
          Navigator.of(context).pop(cid);
        },
      ),
    );
  }
}
