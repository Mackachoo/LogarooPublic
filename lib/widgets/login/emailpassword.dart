import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logbook2electricboogaloo/services/auth.dart';
import 'package:logbook2electricboogaloo/widgets/dialogs.dart';

class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({super.key});

  @override
  State<EmailPasswordLogin> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            emailForm(),
            const SizedBox(height: 15),
            passwordForm(),
            Align(
              alignment: Alignment.centerRight,
              child: forgotPasswordButton(context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                registerButton(context),
                loginButton(context),
              ].map((w) => Transform.scale(scale: 1.2, child: w)).toList(),
            ),
          ]),
        ),
      ),
    );
  }

  Form emailForm() {
    return Form(
        key: _emailKey,
        child: TextFormField(
          autofillHints: const [AutofillHints.username],
          autofocus: true,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.person),
            labelText: "Email",
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (val) {
            if (val == null) {
              return ' Please enter an email address';
            } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(val)) {
              return 'Invalid email address';
            }
            return null;
          },
          onChanged: (val) {
            email = val;
          },
        ));
  }

  Form passwordForm() {
    return Form(
        key: _passwordKey,
        child: TextFormField(
          autofillHints: const [AutofillHints.password],
          autofocus: true,
          decoration: const InputDecoration(
            filled: true,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
            labelText: "Password",
            errorMaxLines: 3,
          ),
          obscureText: true,
          textInputAction: TextInputAction.done,
          validator: (val) {
            if (val == null) {
              return ' Please enter a password';
            } else if (!RegExp(r"^.{8,}$").hasMatch(val)) {
              return 'Your password must have at least 8 characters';
            } else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])")
                .hasMatch(val)) {
              return 'Your password must at least one upper/lowercase letter and a number';
            } else {
              return null;
            }
          },
          onChanged: (val) {
            password = val;
          },
        ));
  }

  TextButton forgotPasswordButton(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.only(right: 0)),
      child: const Text("Forgotten password"),
      onPressed: () async {
        if (_emailKey.currentState!.validate()) {
          conditionalPopup(
              context: context,
              title: const Text("Forgotten password"),
              condition: _auth.emailUserExists(email),
              trueWidget: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),

                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Would you like to reset the password for the account with the email:"),
                    Text(
                      "\n\t$email \n",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      child: const Text("Reset Password"),
                      onPressed: () async {
                        await _auth.resetPassword(email);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
              falseWidget: const Text(
                  "This email address is not registered to an account."));
        }
      },
    );
  }

  ElevatedButton registerButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary),
      child: const Text("Register"),
      onPressed: () async {
        TextInput.finishAutofillContext();
        if (_emailKey.currentState!.validate() &&
            _passwordKey.currentState!.validate()) {
          conditionalPopup(
              context: context,
              title: const Text("Registering a new account"),
              condition: _auth.emailUserExists(email),
              trueWidget: const Text(
                  "This email address is already registered to an account."),
              falseWidget: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    const Text(
                        "Would you like to register a new account with the email:"),
                    Text(
                      "\n\t$email \n",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text("If so please accept our terms and conditions."),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      child: const Text("Accept"),
                      onPressed: () async {
                        Navigator.pop(context);
                        popup(
                            context: context,
                            title: const Text("Registering a new account"),
                            child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Please verify your email or you account will be lost in 30 days.",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  CircularProgressIndicator()
                                ]));
                        Future.delayed(const Duration(seconds: 3));
                        await _auth.registerEmail(email, password);
                      },
                    )
                  ],
                ),
              ));
        }
      },
    );
  }

  ElevatedButton loginButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          backgroundColor: Theme.of(context).colorScheme.primary),
      child: const Text("Log In"),
      onPressed: () async {
        TextInput.finishAutofillContext();
        print(_auth.signInEmail(email, password));
        if (_emailKey.currentState!.validate() &&
            _passwordKey.currentState!.validate()) {
          conditionalPopup(
              context: context,
              condition: _auth.signInEmail(email, password),
              title: const Text("Logging In"),
              trueWidget: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
              falseWidget: const Text("Incorrect login details"));
        }
      },
    );
  }
}
