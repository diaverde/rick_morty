// ----------------------------------------------------
// ----------------Modelos  Provider-------------------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rick_morty/config.dart';
import 'package:rick_morty/models/character.dart';
import 'package:rick_morty/models/location.dart';

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
      //print(response.body);

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

/// Modelo para manejo de estado de ubicaciones
class LocationModel extends ChangeNotifier {
  /// Estado de carga de información de ubicaciones
  LoadStatus loadStatus = LoadStatus.idle;

  /// Lista de ubicaciones
  List<RMLocation> listOfLocations = <RMLocation>[];

  /// Ubicación con más personajes
  String mostRelevantLocation = '';

  /// Función para capturar todas las ubicaciones
  Future<void> getAllLocations() async {
    const int _totalPages = 7;
    loadStatus = LoadStatus.loading;
    notifyListeners();
    for (var i = 1; i <= _totalPages; i++) {
      final result = await getLocations(i);
      if (!result) {
        loadStatus = LoadStatus.error;
        notifyListeners();
        return;
      }
    }
    loadStatus = LoadStatus.loaded;
    mostRelevantLocation = findPopularLocation();
    notifyListeners();
  }

  /// Función para obtener ubicaciones
  Future<bool> getLocations(int page) async {
    final parameter = '?page=$page';
    try {
      final response =
          await http.get(Uri.parse('${Config.locationURL}$parameter'));
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        final myList = temp['results'];
        if (page == 1) {
          listOfLocations.clear();
        }
        for (final item in myList) {
          listOfLocations.add(RMLocation.fromJson(item));
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Función para extraer la ubicación con más personajes
  String findPopularLocation() {
    var maxLocations = 0;
    var popularLocation = '';
    for (final item in listOfLocations) {
      if (item.residents!.length > maxLocations) {
        popularLocation = item.name!;
      }
    }
    return popularLocation;
  }
}

/// Modelo para manejo de estado de episodios
class EpisodeModel extends ChangeNotifier {
  /// Estado de carga de información de episodios
  LoadStatus loadStatus = LoadStatus.idle;

  /// Número de episodios
  int numberOfEpisodes = 0;

  /// Función para obtener personajes
  Future<void> getEpisodes() async {
    try {
      final response = await http.get(Uri.parse(Config.episodeURL));
      //print(response.body);

      if (response.statusCode == 200) {
        final dynamic temp = json.decode(response.body);
        numberOfEpisodes = temp['info']['count'];
        loadStatus = LoadStatus.loaded;
      } else {
        loadStatus = LoadStatus.error;
      }
      notifyListeners();
    } catch (e) {
      loadStatus = LoadStatus.error;
      notifyListeners();
    }
  }
}
