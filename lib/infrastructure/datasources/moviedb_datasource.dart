import 'package:dio/dio.dart';

import 'package:cinemapedia_app/config/constants/enviroment.dart';
import 'package:cinemapedia_app/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response_model.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_detail_model.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_videos.dart';
import 'package:cinemapedia_app/infrastructure/mapers/movie_mapper.dart';
import 'package:cinemapedia_app/infrastructure/mapers/video_mapper.dart';

class MoviedbDatasource implements MovieDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.movieDbBaseUrl, queryParameters: {'api_key': Enviroment.movieDbKey, 'language': Enviroment.language}));

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final moviedbResponse = MoviedbResponseModel.fromJson(json);

    final List<Movie> movies = moviedbResponse.results.where((moviedb) => moviedb.posterPath != 'no-poster').map((moviedb) => MovieMapper.toEntity(moviedb)).toList();

    return movies;
  }

  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getPopular({int page = 1}) async {
    final response = await dio.get('/movie/popular', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getUpcoming({int page = 1}) async {
    final response = await dio.get('/movie/upcoming', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async {
    final response = await dio.get('/movie/top_rated', queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');

    if (response.statusCode != 200) throw Exception('Pelicula con el id: $id no encontrada.');

    final Movie movie = MovieMapper.toEntityDetails(MovieDetailModel.fromJson(response.data));
    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty || query.length < 3) return [];

    final response = await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }

  @override
  Future<List<Video>> getYoutubeVideosById(int movieId) async {
    final response = await dio.get('/movie/$movieId/videos');
    final moviedbVideosReponse = MoviedbVideosResponse.fromJson(response.data);
    final videos = <Video>[];

    for (final moviedbVideo in moviedbVideosReponse.results) {
      if (moviedbVideo.site == 'YouTube') {
        final video = VideoMapper.moviedbVideoToEntity(moviedbVideo);
        videos.add(video);
      }
    }

    return videos;
  }

  @override
  Future<List<Movie>> getSimilarMovies(int movieId) async {
    final response = await dio.get('/movie/$movieId/similar');
    return _jsonToMovies(response.data);
  }
}
