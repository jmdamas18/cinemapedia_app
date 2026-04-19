import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia_app/domain/entities/movie.dart';
import 'package:cinemapedia_app/presentation/delegates/search_movie_delegate.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';

class CustomAppbar extends ConsumerWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              IconButton(icon: const Icon(Icons.movie_outlined), color: colors.primary, onPressed: () {}),

              Text('Cinemapedia', style: titleStyle!.copyWith(color: colors.primary)),

              const Spacer(),

              IconButton(
                icon: const Icon(Icons.search),
                color: colors.primary,
                onPressed: () {
                  final searchedMovies = ref.read(searchedMoviesProvider);
                  final searchQuery = ref.read(searchQueryProvider);

                  showSearch<Movie?>(
                    query: searchQuery,
                    context: context,
                    delegate: SearchMovieDelegate(
                      initialMovies: searchedMovies,
                      searchMovies: ref.read(searchedMoviesProvider.notifier).searchMovies,
                    ),
                  ).then((movie) {
                    if (!context.mounted) return;

                    if (movie == null) return;

                    context.push('/movie/${movie.id}');
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
