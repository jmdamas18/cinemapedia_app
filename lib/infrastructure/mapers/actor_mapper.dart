import 'package:cinemapedia_app/domain/entities/actor.dart';
import 'package:cinemapedia_app/infrastructure/models/moviedb/credit_response_model.dart';
import 'package:cinemapedia_app/config/constants/enviroment.dart';

class ActorMapper {
  static Actor castToEntity(Cast cast) =>
      Actor(id: cast.id, name: cast.name, profilePath: cast.profilePath != null ? '${Enviroment.imageBaseUrl}/w500${cast.profilePath}' : Enviroment.noPhotoProfile, character: cast.character);
}
