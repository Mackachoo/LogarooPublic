import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/logs.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/user.dart';

class TemplateSheet extends StatefulWidget {
  final UserData user;
  final Activity activity;
  final PersistentBottomSheetController? sheetController;
  const TemplateSheet(
      {Key? key,
      required this.user,
      required this.activity,
      required this.sheetController})
      : super(key: key);

  @override
  State<TemplateSheet> createState() => _TemplateSheetState();
}

class _TemplateSheetState extends State<TemplateSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Create Log with template"),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 1),
                        width: 300,
                        shape: StadiumBorder(),
                        content: Text(
                            'Custom templates currently in development',
                            textAlign: TextAlign.center),
                        behavior: SnackBarBehavior.floating,
                      ));
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder<List<Log>>(
                    future: getTemplates(widget.activity),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Wrap(
                          spacing: 10,
                          alignment: WrapAlignment.center,
                          children: snapshot.data!
                              .map((template) => ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  child: Text(template.name),
                                  onPressed: () {
                                    widget.sheetController?.close();
                                    addLog(
                                        activity: widget.activity,
                                        template: template);
                                  }))
                              .toList(),
                        );
                      } else {
                        return const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
