import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/service/anime_service.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/service/personajes_service.dart';
import 'personajes_screen.dart';

class CharactersScreen extends StatefulWidget {
  final String animeGenre;

  CharactersScreen({required this.animeGenre});

  @override
  _CharactersScreenState createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late Future<List<Map<String, dynamic>>> _charactersFuture;

  @override
  void initState() {
    super.initState();
    _charactersFuture = AnimeService().getAnimeList(widget.animeGenre);
  }

  Future<void> _navigateToPersonajesScreen(int animeId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonajesScreen(animeId: animeId),
      ),
    );
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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _charactersFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final allCharacters = snapshot.data!;

                  return ListView.builder(
                    itemCount: allCharacters.length,
                    itemBuilder: (BuildContext context, int index) {
                      final character = allCharacters[index];
                      final coverImage =
                          character['coverImage'] as Map<String, dynamic>?;
                      final title = character['title'] as String?;
                      final type = character['type'] as String?;
                      final genres = character['genres'] as List<dynamic>?;
                      final animeId = character['id'] as int?;

                      return GestureDetector(
                        onTap: () {
                          _navigateToPersonajesScreen(animeId!);
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  coverImage?['large'] as String,
                                  width: 120.0,
                                  height: 160.0,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 120.0,
                                      height: 160.0,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title ?? 'Unknown Title',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text('Type: $type'),
                                      SizedBox(height: 4.0),
                                      Text(
                                          'Genres: ${genres?.join(", ") ?? ""}'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
