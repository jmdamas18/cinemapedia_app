import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/storage/local_storage_provider.dart';

final favoriteMoviesProvider = NotifierProvider<StorageMoviesNotifier, Map<int, Movie>>(StorageMoviesNotifier.new);

class StorageMoviesNotifier extends Notifier<Map<int, Movie>> {
  int page = 0;

  @override
  Map<int, Movie> build() {
    return {};
  }

  Future<void> toggleFavoriteMovie(Movie movie) async {
    final localStorageRepository = ref.read(localStorageRepositoryProvider);

    final bool isFavorite = await localStorageRepository.isMovieFavorite(movie.id);
    await localStorageRepository.toggleFavoriteMovie(movie);

    if (isFavorite) {
      state.remove(movie.id);
      state = {...state};
      return;
    }

    state = {...state, movie.id: movie};
  }

  Future<List<Movie>> loadNextPage() async {
    final localStorageRepository = ref.read(localStorageRepositoryProvider);
    final movies = await localStorageRepository.getFavoriteMovies(limit: 10, offset: page * 10);

    page++;

    // Acumular en un mapa temporal para hacer una sola actualizacion de estado
    final tempMovies = <int, Movie>{};

    for (final movie in movies) {
      tempMovies[movie.id] = movie;
    }

    state = {...state, ...tempMovies};

    return movies;
  }
}
