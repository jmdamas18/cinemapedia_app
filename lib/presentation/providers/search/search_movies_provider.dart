import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';

// — Query provider —
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void update(String query) => state = query;
}

final searchedMoviesProvider = NotifierProvider<SearchedMoviesNotifier, List<Movie>>(SearchedMoviesNotifier.new);

class SearchedMoviesNotifier extends Notifier<List<Movie>> {
  @override
  List<Movie> build() => [];

  Future<List<Movie>> searchMovies(String query) async {
    final movieRepository = ref.read(movieRepositoryProvider);
    final List<Movie> movies = await movieRepository.searchMovies(query);

    ref.read(searchQueryProvider.notifier).update(query);

    state = movies;
    return movies;
  }
}
