// ---------------------------------------------------------------------
// -------------------------Página principal----------------------------
// ---------------------------------------------------------------------

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:rick_morty/provider/character.dart';
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

/// Clase para menú
class HomePageDetails extends StatelessWidget {
  const HomePageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Capturar modelo Provider de Personajes
    final character = context.watch<CharacterModel>();

    return Column(
      children: [
        // Texto de bienvenida
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            children: [
              Text(
                'La serie en números',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Text(
                'Número de episodios: 666',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
              Text(
                'Ubicación con más personajes: Tierra',
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        CharacterListView(character),
      ],
    );
  }
}

class CharacterListView extends StatefulWidget {
  final CharacterModel charModel;
  const CharacterListView(this.charModel, {Key? key}) : super(key: key);

  @override
  _CharacterListViewState createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {
  static const _pageSize = 20;

  final PagingController<int, RMCharacter> _pagingController =
      PagingController(firstPageKey: 10);

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
            itemBuilder: (context, item, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: CachedNetworkImageProvider(item.image!),
                      height: 150,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(224, 224, 224, 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: 150,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, height: 2),
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
                                style: const TextStyle(height: 1.5),
                              ),
                            ],
                          ),
                          Text(
                            item.species!,
                            style: const TextStyle(height: 1.5),
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
                              child: const Text(
                                'Detalle',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
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
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
