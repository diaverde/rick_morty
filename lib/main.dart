// ----------------------------------------------------
// -------Base de aplicación y manejo de rutas---------
// ----------------------------------------------------

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rick_morty/homepage.dart';
import 'package:rick_morty/provider/character.dart';

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
      ],
      child: MaterialApp(
        title: appTitle,
        theme: ThemeData(
          primarySwatch: mainColor,
          highlightColor: const Color.fromRGBO(238, 119, 126, 1),
        ),
        initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => const HomePage(),
        },
      ),
    );
  }
}
