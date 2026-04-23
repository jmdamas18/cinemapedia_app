import 'package:go_router/go_router.dart';

import 'package:cinemapedia_app/presentation/screens/screens.dart';
import 'package:cinemapedia_app/presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => HomeScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  path: 'movie/:id',
                  name: MovieScreen.name,
                  builder: (context, state) => MovieScreen(movieId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/popular', builder: (context, state) => const PopularView())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/top-rated', builder: (context, state) => const TopRatedView())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/favorites', builder: (context, state) => const FavoritesView())],
        ),
      ],
    ),
  ],
);
