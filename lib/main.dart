import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/config/router/app_router.dart';
import 'package:cinemapedia_app/config/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // //* Insertar una película de prueba
  // await db
  //     .into(db.favoriteMovies)
  //     .insert(FavoriteMoviesCompanion.insert(movieId: 1, backdropPath: 'backdrop_path.png', originalTitle: 'My first favorite movie', posterPath: 'poster_path.png', title: 'My first favorite movie'));

  // //* Eliminar todas las películas de prueba
  // final deleteQuery = db.delete(db.favoriteMovies);
  // await deleteQuery.go();

  // //* Consultar todas las películas de prueba
  // final moviesQuery = await db.select(db.favoriteMovies).get();
  // print('items in database: $moviesQuery');

  await dotenv.load();
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter, debugShowCheckedModeBanner: false, theme: AppTheme().getTheme());
  }
}
