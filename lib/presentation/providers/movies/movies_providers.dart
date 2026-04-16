import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);

class MoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;
  bool isLoading = false;

  @override
  List<Movie> build() {
    return [];
  }

  Future<void> loadNextPage() async {
    if (isLoading) return;
    isLoading = true;

    try {
      currentPage++;
      final repository = ref.read(movieRepositoryProvider);
      final List<Movie> movies = await repository.getNowPlaying(page: currentPage);
      state = [...state, ...movies];
    } finally {
      await Future.delayed(const Duration(microseconds: 300));
      isLoading = false;
    }
  }
}
