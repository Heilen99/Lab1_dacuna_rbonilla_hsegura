import 'package:flutter/material.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/service/genre_service.dart';
import 'anime_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GenreService animeService = GenreService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genres List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Genres List'),
        ),
        body: FutureBuilder<List<String>>(
          future: animeService.getGenresList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              final List<String> genreList = snapshot.data!;

              return Container(
                width: double.infinity, // Ancho máximo
                child: ListView.builder(
                  itemCount: (genreList.length / 3).ceil(),
                  itemBuilder: (context, index) {
                    final start = index * 3;
                    final end = start + 3;
                    final genres = genreList.sublist(
                        start, end < genreList.length ? end : genreList.length);

                    return Row(
                      children: genres.map((genre) {
                        return Expanded(
                          child: SizedBox(
                            width: 100, // Ancho fijo
                            height: 60, // Alto fijo
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CharactersScreen(
                                      animeGenre: genre,
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.blue, // Color de fondo
                                child: Container(
                                  alignment:
                                      Alignment.center, // Centrar el texto
                                  child: Text(
                                    genre,
                                    style: TextStyle(
                                      color: Colors.white, // Color del texto
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              );
            } else {
              return Center(
                child: Text('No se encontraron géneros.'),
              );
            }
          },
        ),
      ),
    );
  }
}
