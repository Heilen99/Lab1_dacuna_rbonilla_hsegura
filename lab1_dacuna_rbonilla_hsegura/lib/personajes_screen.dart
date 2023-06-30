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
  late Future<List<Map<String, String>>> _personajesFuture;
  late List<Map<String, String>> _personajesList =
      []; // Initialize with an empty list
  late List<bool> _showAllDataList;

  bool mostrarTodosPersonajes = false;

  @override
  void initState() {
    super.initState();
    _loadPersonajes();
  }

  void _loadPersonajes() async {
    final personajesService = PersonajesService();
    _personajesList =
        await personajesService.getPersonajesAnimeList(widget.animeId);
    _showAllDataList = List<bool>.filled(_personajesList.length, false);

    setState(() {});
  }

  void _toggleShowAllPersonajes() {
    setState(() {
      mostrarTodosPersonajes = !mostrarTodosPersonajes;
    });
  }

  void _toggleShowAllData(int index) {
    setState(() {
      _showAllDataList[index] = !_showAllDataList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personajes del Anime'),
      ),
      body: _personajesList.isNotEmpty
          ? _buildPersonajesList()
          : CircularProgressIndicator(),
    );
  }

  Widget _buildPersonajesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Personajes del Anime',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: mostrarTodosPersonajes ? _personajesList.length : 3,
            itemBuilder: (BuildContext context, int index) {
              final personaje = _personajesList[index];

              return ListTile(
                leading: Image.network(
                  personaje['image']!,
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
                title: Text(personaje['name']!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gender: ${personaje['gender']}'),
                    Text('Age: ${personaje['age']}'),
                    if (_showAllDataList[index])
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${personaje['id']}'),
                          Text(
                              'Description: ${personaje['description'] ?? ""}'),
                          Text('Date of Birth: ${personaje['dateOfBirth']}'),
                          Text('Blood Type: ${personaje['bloodType']}'),
                          Text('Favourites: ${personaje['favourites']}'),
                          TextButton(
                            onPressed: () => _toggleShowAllData(index),
                            child: Text('Ver menos'),
                          ),
                        ],
                      ),
                    if (!_showAllDataList[index])
                      TextButton(
                        onPressed: () => _toggleShowAllData(index),
                        child: Text('Ver más'),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_personajesList.length > 3)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _toggleShowAllPersonajes,
              child: Text(mostrarTodosPersonajes ? 'Ver menos' : 'Ver más'),
            ),
          ),
      ],
    );
  }
}
