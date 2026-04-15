import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movies_repository_provider.dart';

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(MoviesNotifier.new);

class MoviesNotifier extends Notifier<List<Movie>> {
  int currentPage = 0;

  @override
  List<Movie> build() {
    ref.watch(movieRepositoryProvider);
    loadNextPage();
    return [];
  }

  Future<void> loadNextPage() async {
    currentPage++;
    final repository = ref.read(movieRepositoryProvider);
    final List<Movie> movies = await repository.getNowPlaying(page: currentPage);
    state = [...state, ...movies];
  }
}
