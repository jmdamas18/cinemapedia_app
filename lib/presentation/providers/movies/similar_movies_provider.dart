import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movie_repository_provider.dart';

// Provider que obtiene las películas similares a una película por su ID
final similarMoviesProvider = FutureProvider.family<List<Movie>, int>((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getSimilarMovies(movieId);
});
