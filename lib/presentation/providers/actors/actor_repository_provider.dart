import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/infrastructure/datasources/actordb_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/actor_repository_impl.dart';

final actorRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActordbDatasource());
});
