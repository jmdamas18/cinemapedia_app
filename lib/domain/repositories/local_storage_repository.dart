import 'package:cinemapedia_app/domain/entities/movie.dart';

abstract class LocalStorageRepository {
  Future<void> toggleFavoriteMovie(Movie movie);
  Future<bool> isMovieFavorite(int movieId);
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0});
}
