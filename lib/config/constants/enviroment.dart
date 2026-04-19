import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String movieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
  static String movieDbBaseUrl = 'https://api.themoviedb.org/3';
  static String language = 'es-MX';
  static String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static String noImageUrl = 'https://i.stack.imgur.com/GNhxO.png';
  static String noPhotoProfile = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  static String noPoster = 'https://lascrucesfilmfest.com/wp-content/uploads/2018/01/no-poster-available.jpg';
}
