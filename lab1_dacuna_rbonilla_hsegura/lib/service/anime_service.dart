import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class AnimeService {
  final GraphQLClient _client;

  AnimeService() : _client = _createGraphQLClient();

  static GraphQLClient _createGraphQLClient() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co/');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<List<Map<String, dynamic>>> getAnimeList(String genre_in) async {
    final query = gql('''
      query {
        Page(page: 1, perPage: 50) {
          media(genre: "$genre_in", type: ANIME, sort: FAVOURITES_DESC) {
            id
            coverImage {
              large
              color
            }
            title {
              userPreferred
            }
            type
            genres
          }
        }
      }
    ''');

    final options = QueryOptions(
      document: query,
    );

    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      throw Exception('Failed to fetch anime list: ${result.exception}');
    }

    final List<dynamic> animeDataList =
        result.data?['Page']['media'] as List<dynamic>? ?? [];
    final List<Map<String, dynamic>> animeList = animeDataList.map((animeData) {
      final id = animeData['id'] as int?;
      final coverImage = animeData['coverImage'] as Map<String, dynamic>?;
      final title = animeData['title'] as Map<String, dynamic>?;
      final userPreferred = title?['userPreferred'] as String?;
      final type = animeData['type'] as String?;
      final genres = animeData['genres'] as List<dynamic>?;

      return {
        'id': id,
        'coverImage': coverImage,
        'title': userPreferred,
        'type': type,
        'genres': genres,
      };
    }).toList();

    return animeList;
  }
}
