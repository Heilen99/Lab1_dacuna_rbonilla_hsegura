import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/service/personajes_service.dart';

class PersonajesScreen extends StatefulWidget {
  final int animeId;

  PersonajesScreen({required this.animeId});

  @override
  _PersonajesScreenState createState() => _PersonajesScreenState();
}

class _PersonajesScreenState extends State<PersonajesScreen> {
  late Future<List<Map<String, dynamic>>> _personajesFuture;

  @override
  void initState() {
    super.initState();
    _personajesFuture =
        PersonajesService().getPersonajesAnimeList(widget.animeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _personajesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final personajes = snapshot.data!;

            return GridView.count(
              crossAxisCount: 3,
              children: personajes.map((personaje) {
                final imageUrl = personaje['image'] ?? 'No Image';
                final nombre = personaje['name'] ?? 'No Name';
                final edad = personaje['age'] ?? 'Unknown';
                final genero = personaje['gender'] ?? 'Unknown';
                final isExpanded = personaje['isExpanded'] as bool? ?? false;

                final dateOfBirth = personaje['dateOfBirth'];
                final formattedDateOfBirth = dateOfBirth is Map
                    ? formatFuzzyDate(dateOfBirth)
                    : 'Unknown';

                return GestureDetector(
                  onTap: () {
                    _toggleShowAllData(personajes.indexOf(personaje));
                  },
                  child: Card(
                    elevation: 4.0,
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            nombre,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Edad: $edad',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Género: $genero',
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        if (isExpanded)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Descripción:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  personaje['description'] ?? 'No Description',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  'Fecha de nacimiento: $formattedDateOfBirth',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  'Tipo de sangre: ${personaje['bloodType'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  'Favoritos: ${personaje['favourites'] ?? 'Unknown'}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _showCharacterDetails(
                                nombre,
                                imageUrl,
                                personaje['description'] ?? 'No Description',
                                formattedDateOfBirth,
                                personaje['bloodType'] ?? 'Unknown',
                                personaje['favourites'] ?? 'Unknown',
                              );
                            },
                            child: Text(
                              isExpanded ? 'Ver menos' : 'Ver más',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
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
    );
  }

  void _toggleShowAllData(int index) {
    setState(() {
      _personajesFuture.then((personajes) {
        final updatedPersonajes = List<Map<String, dynamic>>.from(personajes);
        updatedPersonajes[index]['isExpanded'] =
            !(updatedPersonajes[index]['isExpanded'] as bool);
        return updatedPersonajes;
      });
    });
  }

  void _showCharacterDetails(
    String characterName,
    String characterImage,
    String characterDescription,
    String characterDateOfBirth,
    String characterBloodType,
    String characterFavourites,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                characterImage,
                width: 100.0,
                height: 160.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100.0,
                    height: 160.0,
                    color: Colors.grey,
                  );
                },
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        characterName,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Descripción:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(characterDescription),
                      SizedBox(height: 8.0),
                      Text('Fecha de nacimiento: $characterDateOfBirth'),
                      Text('Tipo de sangre: $characterBloodType'),
                      Text('Favoritos: $characterFavourites'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  String formatFuzzyDate(Map<dynamic, dynamic> fuzzyDate) {
    final year = fuzzyDate['year'];
    final month = fuzzyDate['month'];
    final day = fuzzyDate['day'];
    return '$day/$month/$year';
  }
}
