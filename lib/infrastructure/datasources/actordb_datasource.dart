import 'package:cinemapedia_app/infrastructure/mapers/actor_mapper.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/credit_response_model.dart';
import 'package:dio/dio.dart';

import 'package:cinemapedia_app/config/constants/enviroment.dart';
import 'package:cinemapedia_app/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia_app/domain/entities/actor.dart';

class ActordbDatasource implements ActorDatasource {
  final dio = Dio(BaseOptions(baseUrl: Enviroment.movieDbBaseUrl, queryParameters: {'api_key': Enviroment.movieDbKey, 'language': Enviroment.language}));

  @override
  Future<List<Actor>> getActorsByMovieId(int movieId) async {
    final response = await dio.get('/movie/$movieId/credits');

    if (response.statusCode != 200) throw Exception('Actores de la pelicula con el id: $movieId no encontrados.');

    final castReponse = CreditResponseModel.fromJson(response.data);

    final List<Actor> actors = castReponse.cast.map((actor) => ActorMapper.castToEntity(actor)).toList();

    return actors;
  }
}
