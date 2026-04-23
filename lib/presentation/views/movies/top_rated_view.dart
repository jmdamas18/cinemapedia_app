import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';

class TopRatedView extends ConsumerStatefulWidget {
  const TopRatedView({super.key});

  @override
  ConsumerState<TopRatedView> createState() => _TopRatedViewState();
}

class _TopRatedViewState extends ConsumerState<TopRatedView> {
  @override
  Widget build(BuildContext context) {
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    if (topRatedMovies.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 3));
    }

    return Scaffold(
      body: MovieMasonry(movies: topRatedMovies.toList(), loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextPage()),
    );
  }
}
