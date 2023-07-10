import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/firestore/centre.dart';
import 'package:logbook2electricboogaloo/services/roles.dart';
import 'package:logbook2electricboogaloo/widgets/dropdown.dart';

class CentreRoles extends StatefulWidget {
  final Centre centre;
  const CentreRoles({super.key, required this.centre});

  @override
  State<CentreRoles> createState() => _CentreRolesState();
}

class _CentreRolesState extends State<CentreRoles> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return SimpleDropdown(
        header: "Roles",
        body: FutureBuilder<List<Role>>(
            future: widget.centre.roles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.separated(
                        physics: const ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length + 2,
                        separatorBuilder: (context, index) => DragTarget(
                              onAcceptWithDetails: (details) {
                                details.data;
                              },
                              builder: (context, candidateData, rejectedData) =>
                                  dragging
                                      ? const Divider()
                                      : const SizedBox.shrink(),
                            ),
                        itemBuilder: (context, index) {
                          if (index == 0 ||
                              index == snapshot.data!.length + 1) {
                            return const SizedBox.shrink();
                          } else {
                            Role role = snapshot.data!
                                .where((element) => element.rank == index - 1)
                                .single;
                            return LayoutBuilder(
                                builder: (context, constraints) =>
                                    LongPressDraggable<Role>(
                                        axis: Axis.vertical,
                                        onDragStarted: () => setState(() {
                                              dragging = true;
                                            }),
                                        onDragCompleted: () => setState(() {
                                              dragging = false;
                                            }),
                                        onDraggableCanceled: (_, __) =>
                                            setState(() {
                                              dragging = false;
                                            }),
                                        data: role,
                                        childWhenDragging: roleRemaining(),
                                        feedback: SizedBox(
                                          width: constraints.maxWidth + 5,
                                          child: roleDragged(context, role),
                                        ),
                                        child: roleButton(context, role)));
                          }
                        }));
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  Widget roleButton(BuildContext context, Role role) {
    return TextButton(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(role.name, maxLines: 1),
        const Icon(Icons.menu_rounded),
      ]),
      onPressed: () {
        if (kDebugMode) {
          print("Short Press");
        }
      },
    );
  }

  Widget roleRemaining() {
    return DottedBorder(
      strokeCap: StrokeCap.round,
      borderType: BorderType.RRect,
      radius: Radius.circular(99),
      color: Theme.of(context).colorScheme.tertiary,
      strokeWidth: 3,
      dashPattern: [10, 10],
      child: SizedBox(height: 30),
    );
  }

  Widget roleDragged(BuildContext context, Role role) {
    return Card(
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(role.name,
              maxLines: 1,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500)),
          // SizedBox(width: width * 0.55),
          Icon(Icons.menu_rounded,
              color: Theme.of(context).colorScheme.primary),
        ]),
      ),
    );
  }
}
