import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lab1_dacuna_rbonilla_hsegura/models/anime_model.dart';

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

  ///
  Future<List<AnimeModel>> getAnimeList() async {
    final query = gql('''
    query FetchAnimeList(\$page: Int, \$perPage: Int) {
      Page(page: \$page, perPage: \$perPage) {
        media {
          id
          bannerImage
          title {
            english
          }
          type
          genres
        }
      }
    }
  ''');

    final options = QueryOptions(
      document: query,
      variables: {'page': 1, 'perPage': 10},
    );

    final QueryResult result = await _client.query(options);
    print(result.data?["Page"]["media"]);

    if (result.hasException) {
      throw Exception('Failed to fetch anime list: ${result.exception}');
    }

    final List<dynamic> animeDataList =
        result.data?['Page']['media'] as List<dynamic>? ?? [];
    print('bien aquí');
    final animeList = animeDataList.map((animeData) {
      final image = animeData['bannerImage'] as String? ??
            'Unknown Image';
      final titleData = animeData['title'] as Map<String, dynamic>?;
      final englishTitle = titleData?['english'] as String?;
      final title = englishTitle != null
          ? AnimeTitleModel(english: englishTitle)
          : AnimeTitleModel(
              english:
                  'Unknown Title'); // Provide a fallback value for the title

      return AnimeModel(
        id: animeData['id'] as int,
        bannerImage: image,
        title: title,
        type: animeData['type'] as String? ??
            'Unknown Type', // Provide a fallback value for the type
        genres: (animeData['genres'] as List<dynamic>?)?.cast<String>() ??
            [], // Provide an empty list as a fallback value for genres
      );
    }).toList();

    print('Anime List:');
    print(animeList);
    animeList.forEach((anime) {
      print('ID: ${anime.id}');
      print('Imagen: ${anime.bannerImage}');
      print('Title: ${anime.title.english}');
      print('Type: ${anime.type}');
      print('Genres: ${anime.genres}');
      print('------------------------');
    });
    return animeList;
  }
}
