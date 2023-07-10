import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/services/firestore/logs.dart';
import 'package:logbook2electricboogaloo/services/style.dart';

class LogCard extends StatefulWidget {
  final Log log;
  final String uid;
  final Activity activity;
  const LogCard(
      {Key? key, required this.log, required this.uid, required this.activity})
      : super(key: key);

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  bool editable = false;
  bool expanded = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth >= 800
            ? (constraints.maxWidth / 2) - 5
            : constraints.maxWidth;
        return GestureDetector(
            onTap: () {
              if (!editable) {
                setState(() {
                  expanded = !expanded;
                });
              }
            },
            child: SizedBox(
              width: cardWidth,
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: () {
                        List<Widget> colList = [];
                        for (int row = 0;
                            row < widget.log.layout.length;
                            row++) {
                          List<Widget> rowList = [];
                          for (int col = 0;
                              col < widget.log.layout[row];
                              col++) {
                            MapEntry<String, dynamic>? field =
                                position2Key(row, col, widget.log.fields);
                            if (field != null) {
                              if (widget.log.visibleRows > row) {
                                rowList.add(Expanded(
                                  child: logField(
                                    log: widget.log,
                                    name: field.key,
                                    value: field.value['value'] ?? "",
                                    type: field.value['type'] ?? "short",
                                    editable: editable,
                                  ),
                                ));
                              } else {
                                rowList.add(Expanded(
                                  child: AnimatedCrossFade(
                                    duration: GlobalStyle().animationDuration,
                                    crossFadeState: expanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: logField(
                                      log: widget.log,
                                      name: field.key,
                                      value: field.value['value'] ?? "",
                                      type: field.value['type'] ?? "short",
                                      editable: editable,
                                    ),
                                  ),
                                ));
                              }
                            }
                          }
                          colList.add(Row(children: rowList));
                        }

                        colList.add(AnimatedCrossFade(
                            duration: GlobalStyle().animationDuration,
                            crossFadeState: expanded
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: const SizedBox.shrink(),
                            secondChild: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: widget.log.deleted
                                      ? const Icon(Icons.delete_forever)
                                      : const Icon(Icons.delete),
                                  onPressed: () {
                                    widget.log.deleted
                                        ? deleteLog(
                                            activity: widget.activity,
                                            log: widget.log)
                                        : updateLog(
                                            activity: widget.activity,
                                            log: widget.log,
                                            name: "_deleted",
                                            value: true);
                                  },
                                ),
                                ElevatedButton(
                                  child: widget.log.deleted
                                      ? const Icon(Icons.restore_page)
                                      : AnimatedCrossFade(
                                          crossFadeState: editable
                                              ? CrossFadeState.showSecond
                                              : CrossFadeState.showFirst,
                                          duration:
                                              GlobalStyle().animationDuration,
                                          firstChild: const Icon(Icons.edit),
                                          secondChild: const Icon(Icons.save),
                                        ),
                                  onPressed: () {
                                    widget.log.deleted
                                        ? updateLog(
                                            activity: widget.activity,
                                            log: widget.log,
                                            name: "_deleted",
                                            value: false)
                                        : setState(() {
                                            if (editable) {
                                              _formkey.currentState?.save();
                                              editable = false;
                                            } else {
                                              editable = true;
                                            }
                                          });
                                  },
                                ),
                              ],
                            )));

                        return colList;
                      }(),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }

  MapEntry<String, dynamic>? position2Key(
      int row, int col, Map<String, dynamic> data) {
    for (var entry in data.entries) {
      if (entry.value["position"][0] == row &&
          entry.value["position"][1] == col) {
        return entry;
      }
    }
    return null;
  }

  Widget logField({
    required Log log,
    required String name,
    required dynamic value,
    required String type,
    required bool editable,
  }) {
    TextEditingController input = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: input,
        enabled: editable,
        readOnly: type == "date" || type == "time",
        decoration: InputDecoration(
            labelText: name,
            labelStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant)),
        maxLines: null,
        textAlign: type == 'long' ? TextAlign.left : TextAlign.center,
        inputFormatters: type.contains("num")
            ? [
                FilteringTextInputFormatter.allow(RegExp("[0-9.,]")),
              ]
            : null,

        // Data or number picker
        onTap: () async {
          if (type == "date") {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                    1783), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(9999));

            if (pickedDate != null) {
              input.text = DateFormat('dd-MM-yyyy').format(pickedDate);
            }
          } else if (type == "time") {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              input.text =
                  MaterialLocalizations.of(context).formatTimeOfDay(pickedTime);
            }
          }
        },

        // Save command
        onSaved: (val) {
          if (type.contains("num") && val != null && val != "") {
            val = type
                .split(':')[1]
                .replaceAll("@", val.replaceAll(RegExp('[A-Za-z. ]'), ""));
          }

          updateLog(
              activity: widget.activity,
              log: log,
              name: "$name.value",
              value: val);
        },
      ),
    );
  }
}
