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
      debugShowCheckedModeBanner: false, // Quitar el banner de "debug"
      title: 'ANIME',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Géneros, seleccione el que desee ver'),
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
                                color: Colors.brown[200], // Color de fondo
                                child: Container(
                                  alignment:
                                      Alignment.center, // Centrar el texto
                                  child: Text(
                                    genre,
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Color del texto en negro
                                      fontSize:
                                          18, // Tamaño de la fuente del texto
                                      fontWeight: FontWeight.bold,
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
