import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/presentation/providers/movies/movie_repository_provider.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';

final movieDetailProvider = NotifierProvider<MovieMapNotifier, Map<String, Movie>>(() => MovieMapNotifier(fetchFunction: (ref) => ref.read(movieRepositoryProvider).getMovieById));

// Tipo para la funcion que carga el detalle de una pelicula por id
typedef MovieDetailCallback = Future<Movie> Function(String movieId);

class MovieMapNotifier extends Notifier<Map<String, Movie>> {
  final MovieDetailCallback Function(Ref ref) fetchFunction;

  MovieMapNotifier({required this.fetchFunction});

  bool isLoading = false;

  @override
  Map<String, Movie> build() {
    return {};
  }

  Future<void> loadMovie(String movieId) async {
    if (state.containsKey(movieId)) return;

    if (isLoading) return;
    isLoading = true;

    try {
      final fetcher = fetchFunction(ref);
      final Movie movie = await fetcher(movieId);
      state = {...state, movieId: movie};
    } finally {
      isLoading = false;
    }
  }
}
