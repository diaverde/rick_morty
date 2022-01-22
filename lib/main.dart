// ----------------------------------------------------
// -------Base de aplicación y manejo de rutas---------
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rick_morty/detail.dart';
import 'package:rick_morty/homepage.dart';
import 'package:rick_morty/provider/provider_models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Rick & Morty App';

    const mainColor = MaterialColor(
      0xFF111166,
      <int, Color>{
        50: Color(0xFF111166),
        100: Color(0xFF111166),
        200: Color(0xFF111166),
        300: Color(0xFF111166),
        400: Color(0xFF111166),
        500: Color(0xFF111166),
        600: Color(0xFF111166),
        700: Color(0xFF111166),
        800: Color(0xFF111166),
        900: Color(0xFF111166),
      },
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CharacterModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocationModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => EpisodeModel(),
        ),
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primarySwatch: mainColor,
          primaryColor: const Color.fromRGBO(77, 188, 195, 1),
          highlightColor: const Color.fromRGBO(255, 255, 0, 1),
          backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
          textTheme: const TextTheme(
            headline1: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                height: 2),
            headline2: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
            headline3: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.5,
                fontSize: 14,
                color: Colors.black),
            bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            button: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const HomePage(),
          '/detail': (context) => const DetailPage(),
        },
      ),
    );
  }
}
