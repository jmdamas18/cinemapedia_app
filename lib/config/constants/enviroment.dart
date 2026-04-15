import 'package:flutter_dotenv/flutter_dotenv.dart';

class Enviroment {
  static String movieDbKey = dotenv.env['THE_MOVIEDB_KEY'] ?? 'No API Key';
  static String movieDbBaseUrl = 'https://api.themoviedb.org/3';
  static String language = 'es-MX';
  static String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static String noImageUrl = 'https://i.stack.imgur.com/GNhxO.png';
}
