import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/anime_service.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/models/anime_model.dart';

import 'characters_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AnimeModel>>(
      future: AnimeService().getAnimeList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final genres = snapshot.data!;

          return MaterialApp(
            title: 'Anilist API',
            theme: ThemeData(
              primarySwatch: Colors.teal,
            ),
            home: AnimeSelectionScreen(animeList: genres),
          );
        }
      },
    );
  }
}

class AnimeSelectionScreen extends StatelessWidget {
  final List<AnimeModel> animeList;
  String selectedGenre = '';

  AnimeSelectionScreen({required this.animeList});

  @override
  Widget build(BuildContext context) {
    // Obtener todos los géneros sin repetir
    List<String> genres = [];
    animeList.forEach((anime) {
      genres.addAll(anime.genres);
    });
    genres = genres.toSet().toList(); // Eliminar duplicados

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar el Género'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: genres.map((genre) {
            return SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  selectedGenre = genre;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CharactersScreen(animeGenre: selectedGenre),
                    ),
                  );
                },
                child: Text(genre),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
