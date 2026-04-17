import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/presentation/providers/actors/actor_repository_provider.dart';
import 'package:cinemapedia_app/domain/entities/actor.dart';

final actorDetailProvider = NotifierProvider<ActorMapNotifier, Map<int, List<Actor>>>(() => ActorMapNotifier(fetchFunction: (ref) => ref.read(actorRepositoryProvider).getActorsByMovieId));

typedef ActorDetailCallback = Future<List<Actor>> Function(int movieId);

class ActorMapNotifier extends Notifier<Map<int, List<Actor>>> {
  final ActorDetailCallback Function(Ref ref) fetchFunction;

  ActorMapNotifier({required this.fetchFunction});

  bool isLoading = false;

  @override
  Map<int, List<Actor>> build() {
    return {};
  }

  Future<void> loadActor(int movieId) async {
    if (state.containsKey(movieId)) return;

    if (isLoading) return;
    isLoading = true;

    try {
      final fetcher = fetchFunction(ref);
      final List<Actor> actors = await fetcher(movieId);
      state = {...state, movieId: actors};
    } finally {
      isLoading = false;
    }
  }
}
