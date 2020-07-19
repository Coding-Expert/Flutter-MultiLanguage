import 'package:flutter/material.dart';
import 'package:testapp/src/page/Home.dart';
import 'package:testapp/src/page/Login.dart';
import 'package:testapp/src/model/DemoLocalization.dart';

void main() => runApp(MaterialApp(
      initialRoute: Login.routeName,
      // locale: Locale("en"),
      // localizationsDelegates: [const DemoLocalizationsDelegate()],
      // supportedLocales: [const Locale('en', ''), const Locale('ar', '')],
      routes: {
        Login.routeName: (context) => Login(),
        Home.routeName: (context) =>
            Home(args: ModalRoute.of(context).settings.arguments)
      },
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

