import 'package:dio/dio.dart';

import 'package:cinemapedia_app/config/constants/enviroment.dart';
import 'package:cinemapedia_app/domain/datasources/movie_datasource.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/moviedb_response_model.dart';
import 'package:cinemapedia_app/infrastructure/mapers/movie_mapper.dart';

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
}
