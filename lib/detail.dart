// ---------------------------------------------------------------------
// -------------------------Página de detalle---------------------------
// ---------------------------------------------------------------------

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_morty/provider/provider_models.dart';

/// Clase principal
class DetailPage extends StatelessWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty App'),
        ),
        body: const DetailPageBody(),
      );
}

/// Clase para menú
class DetailPageBody extends StatelessWidget {
  const DetailPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo Provider de Personajes
    final character = context.watch<CharacterModel>();

    String _numOfEpisodesInfo;
    final _numOfEpisodes = character.currentCharacter.episode!.length;
    if (_numOfEpisodes == 1) {
      _numOfEpisodesInfo = '1 episodio';
    } else {
      _numOfEpisodesInfo = '$_numOfEpisodes episodios';
    }

    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(50),
          padding: const EdgeInsets.all(20),
          color: const Color.fromRGBO(240, 240, 240, 1),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Detalle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 2,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: CachedNetworkImageProvider(
                      character.currentCharacter.image!),
                  height: 220,
                ),
              ),
              Text(
                character.currentCharacter.name!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 3,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 50),
                child: Text(
                  'Género: ${character.currentCharacter.gender!}\n'
                  'Origen: ${character.currentCharacter.origin}\n'
                  'Ubicación: ${character.currentCharacter.location}\n'
                  '$_numOfEpisodesInfo',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
