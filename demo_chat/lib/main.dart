import 'dart:io';
import 'package:demo_chat/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:demo_chat/homePage.dart';
import 'package:demo_chat/chatPage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Speech to Text';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.purple),
        home: HomePage(),
      );
}
