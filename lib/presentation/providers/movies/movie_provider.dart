import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/providers/movies/movie_repository_provider.dart';

final nowPlayingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(() => MoviesNotifier(fetchFunction: (ref) => ref.read(movieRepositoryProvider).getNowPlaying));
final popularMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(() => MoviesNotifier(fetchFunction: (ref) => ref.read(movieRepositoryProvider).getPopular));
final upcomingMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(() => MoviesNotifier(fetchFunction: (ref) => ref.read(movieRepositoryProvider).getUpcoming));
final topRatedMoviesProvider = NotifierProvider<MoviesNotifier, List<Movie>>(() => MoviesNotifier(fetchFunction: (ref) => ref.read(movieRepositoryProvider).getTopRated));

typedef MovieCallback = Future<List<Movie>> Function({int page});

class MoviesNotifier extends Notifier<List<Movie>> {
  // Funcion que determina que endpoint del repositorio se usa
  final MovieCallback Function(Ref ref) fetchFunction;

  MoviesNotifier({required this.fetchFunction});

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
      final fetcher = fetchFunction(ref);
      final List<Movie> movies = await fetcher(page: currentPage);
      state = [...state, ...movies];
    } finally {
      await Future.delayed(const Duration(milliseconds: 100));
      isLoading = false;
    }
  }
}
