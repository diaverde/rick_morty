// ----------------------------------------------------
// ---------Modelo de Personaje para Provider----------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty/config.dart';
import 'package:rick_morty/models/character.dart';

/// Estados de carga
enum LoadStatus {
  /// En espera
  idle,

  /// Cargando
  loading,

  /// Cargado
  loaded,

  /// Error genérico
  error
}

/// Modelo para manejo de estado de personajes
class CharacterModel extends ChangeNotifier {
  /// Mapa para asociar estados y colores
  final Map<String, Color> statusColor = {
    'Alive': Colors.green,
    'Dead': Colors.red,
    'unknown': Colors.grey,
  };

  /// Lista de personajes
  List<RMCharacter> listOfCharacters = <RMCharacter>[];

  /// Personaje seleccionado
  RMCharacter currentCharacter = RMCharacter();

  /// Reiniciar todas las variables de este modelo
  void resetAll() {
    listOfCharacters.clear();
    currentCharacter = RMCharacter();
  }

  /// Función para obtener personajes
  Future<List<RMCharacter>> getCharacters(int page) async {
    final parameter = '?page=$page';
    try {
      final response =
          await http.get(Uri.parse('${Config.characterURL}/$parameter'));
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['results'];
        listOfCharacters.clear();
        for (final item in myList) {
          listOfCharacters.add(RMCharacter.fromJson(item));
        }
        return listOfCharacters;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
