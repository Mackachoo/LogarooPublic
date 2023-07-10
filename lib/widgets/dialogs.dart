import 'package:flutter/material.dart';

void popup(
    {required BuildContext context, Widget? title, required Widget child}) {
  Future.delayed(Duration.zero, () {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
          title: title,
          content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), child: child)),
    );
  });
}

void conditionalPopup(
    {required BuildContext context,
    Widget? title,
    required Future<bool>? condition,
    required Widget trueWidget,
    required Widget falseWidget}) {
  Future.delayed(Duration.zero, () {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: FutureBuilder<bool>(
                future: condition,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  late Widget output;
                  if (snapshot.hasData) {
                    if (snapshot.data == true) {
                      output = trueWidget;
                    } else {
                      output = falseWidget;
                    }
                  } else {
                    output = const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    );
                  }
                  return ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: output);
                }),
          );
        });
  });
}

void textPopups(BuildContext context, String label) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 1),
    width: 300,
    shape: const StadiumBorder(),
    content: Text(label, textAlign: TextAlign.center),
    behavior: SnackBarBehavior.floating,
  ));
}

void developmentPopup(BuildContext context) => textPopups(
    context, 'This feature is currently in development and will be live soon');
