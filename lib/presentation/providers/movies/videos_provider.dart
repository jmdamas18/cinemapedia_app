import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia_app/domain/entities/video.dart';
import 'package:cinemapedia_app/presentation/providers/providers.dart';

final videosFromMovieProvider = FutureProvider.family<List<Video>, int>((ref, int movieId) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return movieRepository.getYoutubeVideosById(movieId);
});
