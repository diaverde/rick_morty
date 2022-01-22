// ---------------------------------------------------------------------
// -------------------------Página de detalle---------------------------
// ---------------------------------------------------------------------

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:rick_morty/provider/character.dart';
import 'package:rick_morty/models/character.dart';

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

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(
                'Detalle',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Image(
                image: CachedNetworkImageProvider(
                    character.currentCharacter.image!),
                height: 100,
              ),
              Text(
                character.currentCharacter.name!,
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Text(
                '${character.currentCharacter.gender!}\n'
                '${character.currentCharacter.origin!.name}\n'
                '${character.currentCharacter.location!.name}\n'
                '${character.currentCharacter.episode!.length} episodio(s)\n',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
