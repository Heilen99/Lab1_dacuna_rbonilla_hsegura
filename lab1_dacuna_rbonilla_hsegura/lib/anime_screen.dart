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

                      return ListTile(
                        onTap: () {
                          _navigateToPersonajesScreen(animeId!);
                        },
                        leading: Image.network(
                          coverImage?['large'] as String,
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
                        title: Text(title ?? 'Unknown Title'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Type: $type'),
                            Text('Genres: ${genres?.join(", ") ?? ""}'),
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
