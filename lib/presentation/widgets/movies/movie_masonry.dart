import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/widgets/movies/movie_poster_link.dart';

class MovieMasonry extends StatefulWidget {
  final List<Movie> movies;
  final Future<List<Movie>> Function()? loadNextPage;

  const MovieMasonry({super.key, required this.movies, this.loadNextPage});

  @override
  State<MovieMasonry> createState() => _MovieMasonryState();
}

class _MovieMasonryState extends State<MovieMasonry> {
  bool isLoading = false;
  bool isLastPage = false;
  final scrollController = ScrollController();

  void loadNextPageMovies() async {
    if (isLoading || isLastPage) return;

    if (widget.loadNextPage == null) return;

    isLoading = true;
    final movies = await widget.loadNextPage!();

    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      // Si el scroll está al final o cerca de unos 200px, aquí llamar el loadNextPage
      if (scrollController.position.pixels + 200 >= scrollController.position.maxScrollExtent) {
        loadNextPageMovies();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              children: [
                const SizedBox(height: 20),
                MoviePosterLink(movie: widget.movies[index]),
              ],
            );
          }
          return MoviePosterLink(movie: widget.movies[index]);
        },
      ),
    );
  }
}
