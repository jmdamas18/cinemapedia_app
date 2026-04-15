class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String originalLanguage;
  final bool adult;
  final String overview;
  final List<String> genreIds;
  final bool video;
  final String posterPath;
  final String backdropPath;
  final double popularity;
  final double voteAverage;
  final int voteCount;
  final DateTime releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalLanguage,
    required this.adult,
    required this.overview,
    required this.genreIds,
    required this.video,
    required this.posterPath,
    required this.backdropPath,
    required this.popularity,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
  });
}
