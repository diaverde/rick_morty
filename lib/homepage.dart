// ---------------------------------------------------------------------
// -------------------------Página principal----------------------------
// ---------------------------------------------------------------------

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:rick_morty/config.dart';

import 'package:rick_morty/provider/provider_models.dart';
import 'package:rick_morty/models/character.dart';

/// Clase principal
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty App'),
        ),
        body: const HomePageDetails(),
      );
}

/// Contenido de la página
class HomePageDetails extends StatelessWidget {
  const HomePageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo Provider de Personajes
    final character = context.watch<CharacterModel>();
    // Capturar modelo Provider de Ubicaciones
    final location = context.watch<LocationModel>();
    // Capturar modelo Provider de Episodios
    final episode = context.watch<EpisodeModel>();
    if (location.loadStatus == LoadStatus.idle &&
        episode.loadStatus == LoadStatus.idle) {
      loadShowData(episode, location);
    }

    return Column(
      children: [
        const ShowNumbers(),
        CharacterListView(character),
      ],
    );
  }

  // Función para cargar datos de la API
  void loadShowData(EpisodeModel episode, LocationModel location) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    location.getAllLocations();
    episode.getEpisodes();
  }
}

// Lista de personajes
class CharacterListView extends StatefulWidget {
  final CharacterModel charModel;
  const CharacterListView(this.charModel, {Key? key}) : super(key: key);

  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  // Número de personajes por página
  static const _pageSize = 20;

  final PagingController<int, RMCharacter> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await widget.charModel.getCharacters(pageKey);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) => Expanded(
        child: PagedListView<int, RMCharacter>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<RMCharacter>(
            itemBuilder: (context, item, index) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: (kIsWeb &&
                      MediaQuery.of(context).size.width > Config.minWebSize)
                  ? EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.2)
                  : null,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: CachedNetworkImageProvider(item.image!),
                      height: 120,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name!,
                            style: Theme.of(context).textTheme.headline2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Icon(
                                  Icons.circle,
                                  color:
                                      widget.charModel.statusColor[item.status],
                                  size: 14,
                                ),
                              ),
                              Text(
                                item.status!,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ),
                          Text(
                            item.species!,
                            style: Theme.of(context).textTheme.bodyText1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).highlightColor,
                              ),
                              onPressed: () {
                                widget.charModel.currentCharacter = item;
                                Navigator.pushNamed(context, '/detail');
                              },
                              child: Text(
                                'Detalle',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text(
                'No se encontraron personajes.\n'
                'Verifique conexión e intente de nuevo.',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

/// Clase para números de la serie
class ShowNumbers extends StatelessWidget {
  const ShowNumbers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo Provider de Ubicaciones
    final location = context.watch<LocationModel>();
    // Capturar modelo Provider de Episodios
    final episode = context.watch<EpisodeModel>();

    // Plantilla del widget a retornar
    Widget dataSection(Widget content) => Container(
          padding: const EdgeInsets.all(15),
          color: Theme.of(context).backgroundColor,
          height: 120,
          child: content,
        );

    // Varias posibilidades según estado de carga de información
    if (location.loadStatus == LoadStatus.loading ||
        episode.loadStatus == LoadStatus.loading) {
      return dataSection(
        Center(
          child: Column(
            children: [
              Text(
                'Cargando información:\n',
                style: Theme.of(context).textTheme.headline3,
              ),
              const CircularProgressIndicator()
            ],
          ),
        ),
      );
    } else if (location.loadStatus == LoadStatus.error ||
        episode.loadStatus == LoadStatus.error) {
      return dataSection(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error de conexión\n',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                'Intente de nuevo más tarde o \n'
                'contacte al administrador del sitio.',
                style: Theme.of(context).textTheme.headline3,
              )
            ],
          ),
        ),
      );
    } else if (location.loadStatus == LoadStatus.loaded &&
        episode.loadStatus == LoadStatus.loaded) {
      return dataSection(
        Center(
          child: Column(
            children: [
              Text(
                'La serie en números',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Text(
                'Número de episodios: ${episode.numberOfEpisodes}',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
              Text(
                'Ubicación con más personajes: ${location.mostRelevantLocation}',
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return dataSection(
        Container(),
      );
    }
  }
}
