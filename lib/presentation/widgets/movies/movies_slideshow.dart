import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:go_router/go_router.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';

class MoviesSlideshow extends StatelessWidget {
  final List<Movie> movies;

  const MoviesSlideshow({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: true,
        pagination: SwiperPagination(
          margin: const EdgeInsets.only(top: 0),
          builder: DotSwiperPaginationBuilder(activeColor: colors.primary, color: colors.secondary.withAlpha(100), size: 10, activeSize: 12),
        ),
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int index) => _Slide(movie: movies[index]),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Movie movie;

  const _Slide({required this.movie});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 10))],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: DecoratedBox(
        decoration: decoration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            movie.posterPath,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress != null) {
                return DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20)),
                );
              }

              // return FadeIn(child: child);
              return GestureDetector(
                child: FadeIn(child: child),
                onTap: () => context.push('/home/0/movie/${movie.id}'),
              );
            },
          ),
        ),
      ),
    );
  }
}
