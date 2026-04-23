import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/presentation/widgets/widgets.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/config/helpers/human_formats.dart';

class MovieScreen extends ConsumerStatefulWidget {
  static const name = 'movie-screen';

  final String movieId;

  const MovieScreen({super.key, required this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    super.initState();

    ref.read(movieDetailProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorDetailProvider.notifier).loadActor(int.parse(widget.movieId));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movieDetails = ref.watch(movieDetailProvider)[widget.movieId];

    if (movieDetails == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 3)));
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movieDetails),

          SliverList(delegate: SliverChildBuilderDelegate((context, index) => _MovieDetails(movie: movieDetails), childCount: 1)),
        ],
      ),
    );
  }
}

class _MovieDetails extends StatelessWidget {
  final Movie movie;

  const _MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Titulo, OverView y Rating
        _TitleAndOverview(movie: movie, size: size, textStyles: textStyles),

        //* Generos de la película
        _Genres(movie: movie),

        //* Actores de la película
        ActorsByMovie(movieId: movie.id),

        //* Videos de la película (si tiene)
        VideosFromMovie(movieId: movie.id),

        //* Películas similares
        SimilarMovies(movieId: movie.id),

        const SizedBox(height: 50),
      ],
    );
  }
}

class _TitleAndOverview extends StatelessWidget {
  const _TitleAndOverview({required this.movie, required this.size, required this.textStyles});

  final Movie movie;
  final Size size;
  final TextTheme textStyles;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //* Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(movie.posterPath, width: size.width * 0.3),
          ),

          const SizedBox(width: 10),

          //* Descripción
          SizedBox(
            width: (size.width - 40) * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleLarge),
                Text(movie.overview),

                const SizedBox(height: 10),

                //* MovieRating(voteAverage: movie.voteAverage),
                Row(
                  children: [
                    const Text('Estreno:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 5),
                    Text(HumanFormats.shortDate(movie.releaseDate)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Genres extends StatelessWidget {
  final Movie movie;

  const _Genres({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            ...movie.genreIds.map(
              (gender) => Container(
                margin: const EdgeInsets.only(right: 5),
                child: Chip(
                  label: Text(gender),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.sizeOf(context);
    final isFavoriteFuture = ref.watch(isFavoriteMovieProvider(movie.id));

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            await ref.read(favoriteMoviesProvider.notifier).toggleFavoriteMovie(movie);
            // Invalida el provider para que vuelva a consultar la BD
            ref.invalidate(isFavoriteMovieProvider(movie.id));
          },
          icon: isFavoriteFuture.when(
            data: (isFavorite) => isFavorite ? const Icon(Icons.favorite_rounded, color: Colors.red) : const Icon(Icons.favorite_border),
            error: (_, _) => throw Exception('Error al cargar el estado de favoritos.'),
            loading: () => const CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        // title: Text(
        //   movie.title,
        //   textAlign: TextAlign.start,
        //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        // ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  return FadeIn(child: child);
                },
              ),
            ),

            //* Sobra para el título
            const _CustomGradient(colors: [Colors.transparent, Colors.black87], stops: [0.7, 1]),

            //* Sombra para boton de regresar
            const _CustomGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black87, Colors.transparent], stops: [0.0, 0.4]),

            //* Sombra para el boton de favoritos
            const _CustomGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [Colors.black87, Colors.transparent], stops: [0.0, 0.4]),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final List<Color> colors;
  final List<double> stops;

  const _CustomGradient({this.begin = Alignment.topCenter, this.end = Alignment.bottomCenter, required this.colors, required this.stops});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: begin, end: end, colors: colors, stops: stops),
        ),
      ),
    );
  }
}
