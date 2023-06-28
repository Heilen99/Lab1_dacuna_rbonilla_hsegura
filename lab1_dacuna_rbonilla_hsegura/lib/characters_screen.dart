import 'package:flutter/material.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/models/anime_model.dart';
import 'anime_service.dart';

class CharactersScreen extends StatefulWidget {
  final String animeGenre;

  CharactersScreen({required this.animeGenre});

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late Future<List<AnimeModel>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = AnimeService().getAnimeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Series de Anime'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Selected Genre: ${widget.animeGenre}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AnimeModel>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allCharacters = snapshot.data!;

                  // Filtrar los animes por el género especificado
                  final filteredCharacters = allCharacters
                      .where(
                          (anime) => anime.genres.contains(widget.animeGenre))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredCharacters.length,
                    itemBuilder: (BuildContext context, int index) {
                      final character = filteredCharacters[index];
                      return ListTile(
                        leading: Image.network(
                          '${character.bannerImage}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 100,
                              color: Colors.white, // Mostrar imagen en blanco
                            );
                          },
                        ),
                        title: Text(character.title.english ?? 'Unknown Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: ${character.type}'),
                            Text('Genres: ${character.genres.join(", ")}'),
                          ],
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
