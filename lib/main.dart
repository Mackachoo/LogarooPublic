import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logbook2electricboogaloo/routes/admin.dart';
import 'package:logbook2electricboogaloo/routes/authentication.dart';
import 'package:logbook2electricboogaloo/routes/activities.dart';
import 'package:logbook2electricboogaloo/routes/account.dart';
import 'package:logbook2electricboogaloo/routes/centres.dart';
import 'package:logbook2electricboogaloo/routes/login.dart';
import 'package:logbook2electricboogaloo/routes/logbook.dart';
import 'package:logbook2electricboogaloo/routes/manifest.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logbook2electricboogaloo/services/style.dart';
import 'package:logbook2electricboogaloo/services/firestore/activities.dart';
import 'package:logbook2electricboogaloo/widgets/route.dart';
import 'package:logbook2electricboogaloo/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ApplicationLayer());
}

class ApplicationLayer extends StatelessWidget {
  const ApplicationLayer({Key? key}) : super(key: key);
  final bool lightmode = true;

  // Application root
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          GlobalStyle().scuba(lightmode).colorScheme.tertiary,
    ));

    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'GB'),
        // Locale('de', 'DE'),
      ],
      locale: const Locale('en', 'GB'),
      theme: GlobalStyle().scuba(lightmode),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return RevealRoute(
                page: const Login(), centerAlignment: Alignment.bottomLeft);
          case '/activities':
            return RevealRoute(
                page: const Activities(),
                centerAlignment: Alignment.bottomLeft);
          case '/logbook':
            return RevealRoute(
                page: Logbook(activity: settings.arguments as Activity),
                centerAlignment: Alignment.bottomCenter);
          case '/centres':
            return RevealRoute(
              page: Centres(activity: settings.arguments as Activity),
              centerAlignment: Alignment.bottomCenter,
            );
          case '/manifest':
            return RevealRoute(
                page: Manifest(activity: settings.arguments as Activity),
                centerAlignment: Alignment.bottomCenter);
          case '/account':
            return RevealRoute(
                page: const Account(), centerAlignment: Alignment.topRight);
          case '/admin':
            return RevealRoute(
                page: Admin(cid: settings.arguments as String),
                centerAlignment: Alignment.topLeft);
          default:
            return null;
        }
      },
      routes: {
        '/': (context) => const AuthenticationRoute(),
      },
    );
  }
}
