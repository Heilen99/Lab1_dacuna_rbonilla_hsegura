import 'package:graphql_flutter/graphql_flutter.dart';

class GenreService {
  static GraphQLClient _createGraphQLClient() {
    final HttpLink httpLink = HttpLink('https://graphql.anilist.co/');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<List<String>> getGenresList() async {
    final query = gql('''
      query {
        GenreCollection
      }
    ''');

    final response = await getClient().query(QueryOptions(document: query));

    if (response.hasException) {
      throw response.exception!;
    }

    final List<dynamic> genres = response.data!['GenreCollection'];
    final List<String> genreList = genres.cast<String>();

    return genreList;
  }

  GraphQLClient getClient() {
    return _createGraphQLClient();
  }
}
