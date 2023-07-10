import 'package:flutter/material.dart';
import 'package:logbook2electricboogaloo/services/style.dart';

class SimpleDropdown extends StatefulWidget {
  final String header;
  final Widget body;
  const SimpleDropdown({super.key, required this.header, required this.body});

  @override
  State<SimpleDropdown> createState() => _SimpleDropdownState();
}

class _SimpleDropdownState extends State<SimpleDropdown> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          header(context),
          AnimatedCrossFade(
              duration: GlobalStyle().animationDuration,
              crossFadeState: expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: widget.body)
        ],
      ),
    );
  }

  InkWell header(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          expanded = !expanded;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(widget.header,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.tertiary)),
          Icon(expanded ? Icons.expand_less : Icons.expand_more)
        ]),
      ),
    );
  }
}
