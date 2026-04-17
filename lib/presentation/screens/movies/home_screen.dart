import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:cinemapedia_app/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showNavBar = true;
  double _lastScrollOffset = 0;

  // Controla la visibilidad del nav bar segun la direccion del scroll
  void onScroll(double offset) {
    final isScrollingDown = offset > _lastScrollOffset;
    _lastScrollOffset = offset;

    if (isScrollingDown && _showNavBar) {
      setState(() => _showNavBar = false);
    } else if (!isScrollingDown && !_showNavBar) {
      setState(() => _showNavBar = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _HomeView(onScroll: onScroll)),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _showNavBar ? kBottomNavigationBarHeight : 0,
        child: const SingleChildScrollView(child: CustomBottomNavigation()),
      ),
    );
  }
}

class _HomeView extends ConsumerStatefulWidget {
  final void Function(double offset) onScroll;

  const _HomeView({required this.onScroll});

  @override
  ConsumerState<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<_HomeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
    ref.read(popularMoviesProvider.notifier).loadNextPage();
    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
    ref.read(topRatedMoviesProvider.notifier).loadNextPage();

    _scrollController.addListener(() {
      widget.onScroll(_scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader();

    final slideshow = ref.watch(moviesSlideshowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(centerTitle: false, titlePadding: EdgeInsets.all(0), title: CustomAppbar()),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return Column(
              children: [
                //* Slideshow
                MoviesSlideshow(movies: slideshow),

                //* Lista En Cines
                MoviesHorizontalListview(
                  movies: nowPlayingMovies,
                  title: 'En Cines',
                  subTitle: '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  loadNextPage: () {
                    ref.read(nowPlayingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                //* Lista Proximamente
                MoviesHorizontalListview(
                  movies: upcomingMovies,
                  title: 'Proximamente',
                  subTitle: 'En este mes',
                  loadNextPage: () {
                    ref.read(upcomingMoviesProvider.notifier).loadNextPage();
                  },
                ),

                //* Lista Populares
                MoviesHorizontalListview(
                  movies: popularMovies,
                  title: 'Populares',
                  loadNextPage: () {
                    ref.read(popularMoviesProvider.notifier).loadNextPage();
                  },
                ),

                //* Lista Mejor Valoradas
                MoviesHorizontalListview(
                  movies: topRatedMovies,
                  title: 'Mejor valoradas',
                  subTitle: 'Desde siempre',
                  loadNextPage: () {
                    ref.read(topRatedMoviesProvider.notifier).loadNextPage();
                  },
                ),

                const SizedBox(height: 10),
              ],
            );
          }, childCount: 1),
        ),
      ],
    );
  }
}
