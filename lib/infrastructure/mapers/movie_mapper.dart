import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb_model.dart';
import 'package:cinemapedia_app/config/constants/enviroment.dart';

class MovieMapper {
  static Movie toEntity(MovieMoviedbModel moviedb) => Movie(
    adult: moviedb.adult,
    backdropPath: moviedb.backdropPath != '' ? '${Enviroment.imageBaseUrl}/w500${moviedb.backdropPath}' : Enviroment.noImageUrl,
    genreIds: moviedb.genreIds.map((element) => element.toString()).toList(),
    id: moviedb.id,
    originalLanguage: moviedb.originalLanguage,
    originalTitle: moviedb.originalTitle,
    overview: moviedb.overview,
    popularity: moviedb.popularity,
    posterPath: moviedb.posterPath != '' ? '${Enviroment.imageBaseUrl}/w500${moviedb.posterPath}' : 'no-poster',
    releaseDate: moviedb.releaseDate ?? DateTime.now(),
    title: moviedb.title,
    video: moviedb.video,
    voteAverage: moviedb.voteAverage,
    voteCount: moviedb.voteCount,
  );
}
