import 'package:cinemapedia_app/domain/datasources/actor_datasource.dart';
import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/domain/repositories/actor_repository.dart';

class ActorRepositoryImpl implements ActorRepository {
  final ActorDatasource datasource;

  ActorRepositoryImpl(this.datasource);

  @override
  Future<List<Actor>> getActorsByMovieId(int movieId) {
    return datasource.getActorsByMovieId(movieId);
  }
}
