import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsCard extends StatefulWidget {
  final bool editable;
  final Map<String, dynamic> fields;
  final void Function(String k, String v) update;
  const SettingsCard(
      {Key? key,
      required this.editable,
      required this.fields,
      required this.update})
      : super(key: key);

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: () {
            List<Widget> output = [];
            widget.fields.forEach((k, v) {
              output.add(field(k, v));
              output.add(const SizedBox(height: 10));
            });
            output.removeLast();
            return output;
          }(),
        ),
      ),
    );
  }

  Widget field(
    String k,
    String v,
  ) {
    TextEditingController input = TextEditingController(text: v);
    return Row(
      children: [
        Text(
          k,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: input,
            enabled: widget.editable,
            maxLines: 1,
            textAlign: TextAlign.right,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[A-Za-z.,@ ']"))
            ],
            decoration:
                InputDecoration.collapsed(hintText: v == "" ? "???" : ""),
            onSaved: (val) {
              widget.update(k, val ?? v);
            },
          ),
        ),
      ],
    );
  }
}
