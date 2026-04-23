import 'package:drift/drift.dart' as drift;

import 'package:cinemapedia_app/config/database/database.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/datasources/local_storage_datasource.dart';

class DriftDatasource implements LocalStorageDatasource {
  final AppDatabase database;

  DriftDatasource([AppDatabase? databaseToUse]) : database = databaseToUse ?? db;

  @override
  Future<void> toggleFavoriteMovie(Movie movie) async {
    final isFavorite = await isMovieFavorite(movie.id);

    if (isFavorite) {
      // Contruir un query
      final deleteQuery = database.delete(database.favoriteMovies)..where((table) => table.movieId.equals(movie.id));

      // Ejecutar el query
      await deleteQuery.go();

      return;
    }

    // Contruir un query
    await database
        .into(database.favoriteMovies)
        .insert(
          FavoriteMoviesCompanion.insert(
            movieId: movie.id,
            backdropPath: movie.backdropPath,
            originalTitle: movie.originalTitle,
            posterPath: movie.posterPath,
            title: movie.title,
            voteAverage: drift.Value(movie.voteAverage),
          ),
        );
  }

  @override
  Future<bool> isMovieFavorite(int movieId) async {
    // Contruir un query
    final query = database.select(database.favoriteMovies)..where((table) => table.movieId.equals(movieId));

    // Ejecurtar el query
    final favoriteMovie = await query.getSingleOrNull();

    // Retornar el resultado
    return favoriteMovie != null;
  }

  @override
  Future<List<Movie>> getFavoriteMovies({int limit = 10, int offset = 0}) async {
    // Contruir un query
    final query = database.select(database.favoriteMovies)..limit(limit, offset: offset);

    // Ejecutar el query
    final favoriteMoviesRows = await query.get();

    // Retornar el resultado
    final favoriteMovies = favoriteMoviesRows
        .map(
          (row) => Movie(
            id: row.movieId,
            backdropPath: row.backdropPath,
            originalTitle: row.originalTitle,
            posterPath: row.posterPath,
            title: row.title,
            voteAverage: row.voteAverage,
            originalLanguage: '',
            adult: false,
            overview: '',
            genreIds: [],
            video: false,
            popularity: 0.0,
            voteCount: 0,
            releaseDate: DateTime.now(),
          ),
        )
        .toList();

    // Retornar el resultado
    return favoriteMovies;
  }
}
