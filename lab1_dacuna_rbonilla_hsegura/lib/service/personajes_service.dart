import 'package:graphql_flutter/graphql_flutter.dart';

class PersonajesService {
  final GraphQLClient _client;

  PersonajesService() : _client = _createGraphQLClient();

  static GraphQLClient _createGraphQLClient() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co/');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<List<Map<String, String>>> getPersonajesAnimeList(int seriesId) async {
    final query = gql('''
      query (\$seriesId: Int) {
        Media(id: \$seriesId, type: ANIME) {
          characters(sort: FAVOURITES_DESC) {
            nodes {
              id
              name {
                full
              }
              image {
                large
              }
              description
              gender
              age
              dateOfBirth {
                year
                month
                day
              }
              bloodType
              favourites
            }
          }
        }
      }
    ''');

    final options = QueryOptions(
      document: query,
      variables: {'seriesId': seriesId},
    );

    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      throw Exception('Failed to fetch anime characters: ${result.exception}');
    }

    final Map<String, dynamic>? mediaData =
        result.data?['Media'] as Map<String, dynamic>?;
    final List<dynamic>? characterNodes =
        mediaData?['characters']['nodes'] as List<dynamic>?;

    final List<Map<String, String>> characterList =
        characterNodes?.map((characterData) {
              final id = characterData['id'].toString();
              final name =
                  characterData['name']?['full'].toString() ?? 'Unknown';
              final image = characterData['image']?['large'].toString() ?? '';
              final description = characterData['description'].toString() ?? '';
              final gender = characterData['gender'].toString() ?? '';
              final age = characterData['age'].toString() ?? '';
              final dateOfBirth =
                  characterData['dateOfBirth']?.toString() ?? '';
              final bloodType = characterData['bloodType'].toString() ?? '';
              final favourites = characterData['favourites']?.toString() ?? '';

              return {
                'id': id,
                'name': name,
                'image': image,
                'description': description,
                'gender': gender,
                'age': age,
                'dateOfBirth': dateOfBirth,
                'bloodType': bloodType,
                'favourites': favourites,
              };
            }).toList() ??
            [];

    return characterList;
  }
}
