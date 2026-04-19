import 'dart:async';

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:cinemapedia_app/config/helpers/human_formats.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMovieCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debounceMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debounceTimer;

  SearchMovieDelegate({required this.searchMovies, required this.initialMovies});

  void _onQueryChanged(String query) {
    if (query.isEmpty) {
      debounceMovies.add(initialMovies);
      return;
    }

    isLoadingStream.add(true);

    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      final movies = await searchMovies(query);
      initialMovies = movies;
      debounceMovies.add(initialMovies);
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debounceMovies.close();
    isLoadingStream.close();
  }

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return SpinPerfect(infinite: true, child: const IconButton(icon: Icon(Icons.refresh_rounded), onPressed: null));
          }

          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              icon: const Icon(Icons.clear_rounded),
              onPressed: () {
                query = '';
              },
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: () {
        clearStreams();
        close(context, null);
      },
    );
  }

  Widget _buildMovieList() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debounceMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];

        if (movies.isEmpty) {
          return Center(
            child: Text(query.isEmpty ? 'Escribe para buscar' : 'No se encontraron resultados'),
          );
        }

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(
            movie: movies[index],
            onMovieSelected: (context, movie) {
              clearStreams();
              close(context, movie);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildMovieList();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onQueryChanged(query);
    return _buildMovieList();
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  final void Function(BuildContext, Movie) onMovieSelected;

  const _MovieItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => onMovieSelected(context, movie),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            //* Poster
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  movie.posterPath,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) => FadeIn(child: child),
                ),
              ),
            ),

            const SizedBox(width: 10),

            //* Titulo y descripción
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyles.titleMedium),

                  (movie.overview.isNotEmpty && movie.overview.length > 100)
                      ? Text('${movie.overview.substring(0, 100)}...', style: textStyles.bodyMedium)
                      : Text(movie.overview, style: textStyles.bodyMedium),

                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow.shade800, size: 15),
                      const SizedBox(width: 5),
                      Text(HumanFormats.number(movie.voteAverage, 1), style: textStyles.bodyMedium!.copyWith(color: Colors.yellow.shade900)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
