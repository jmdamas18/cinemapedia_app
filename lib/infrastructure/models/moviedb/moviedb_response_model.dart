import 'package:cinemapedia_app/infrastructure/models/moviedb/movie_moviedb_model.dart';

class MoviedbResponseModel {
  final Dates? dates;
  final int page;
  final List<MovieMoviedbModel> results;
  final int totalPages;
  final int totalResults;

  MoviedbResponseModel({this.dates, required this.page, required this.results, required this.totalPages, required this.totalResults});

  factory MoviedbResponseModel.fromJson(Map<String, dynamic> json) => MoviedbResponseModel(
    dates: json["dates"] != null ? Dates.fromJson(json["dates"]) : null,
    page: json["page"],
    results: List<MovieMoviedbModel>.from(json["results"].map((x) => MovieMoviedbModel.fromJson(x))),
    totalPages: json["total_pages"],
    totalResults: json["total_results"],
  );

  Map<String, dynamic> toJson() => {"dates": dates?.toJson(), "page": page, "results": List<dynamic>.from(results.map((x) => x.toJson())), "total_pages": totalPages, "total_results": totalResults};
}

class Dates {
  final DateTime maximum;
  final DateTime minimum;

  Dates({required this.maximum, required this.minimum});

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
    maximum: json["maximum"] != null ? DateTime.parse(json["maximum"]) : throw Exception("Maximum date not found"),
    minimum: json["minimum"] != null ? DateTime.parse(json["minimum"]) : throw Exception("Minimum date not found"),
  );

  Map<String, dynamic> toJson() => {
    "maximum": "${maximum.year.toString().padLeft(4, '0')}-${maximum.month.toString().padLeft(2, '0')}-${maximum.day.toString().padLeft(2, '0')}",
    "minimum": "${minimum.year.toString().padLeft(4, '0')}-${minimum.month.toString().padLeft(2, '0')}-${minimum.day.toString().padLeft(2, '0')}",
  };
}
