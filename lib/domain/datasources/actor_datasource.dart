import 'package:cinemapedia_app/domain/entities/actor.dart';

abstract class ActorDatasource {
  Future<List<Actor>> getActorsByMovieId(String movieId);
}
