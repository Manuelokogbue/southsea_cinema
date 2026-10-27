import 'package:southsea_cinema/models/movie.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MovieRepository {
  List<Movie>? _cachedMovies;

  List<Movie> getMovies() {
    final List<Movie>? cachedMovies = _cachedMovies;
    if (cachedMovies != null) {
      return cachedMovies;
    }

    return const [
      Movie(
          id: 'Anna',
          name: 'ANNABELLE',
          description:
              'A couple begins to experience terrifying supernatural occurrences involving a vintage doll shortly after their home is invaded by satanic cultists.',
          showingDateTime: 'Friday 30th Oct, 2026 12:00PM',
          imagePath: 'assets/images/Annabelle.jpeg',
          rating: 'IMDB Rating: 7.67',
          duration: '2hrs 45mins',
          pg: '18',
          genre: 'Horror',
          price: 9.5),
      Movie(
          id: 'Hamil',
          name: 'HAMILTON',
          description:
              "The real life of one of America's foremost founding fathers and first Secretary of the Treasury, Alexander Hamilton. Captured live on Broadway from the Richard Rodgers Theater with the original Broadway cast.",
          showingDateTime: 'Sunday 25th October, 2026 09:00AM',
          imagePath: 'assets/images/Hamilton.jpeg',
          rating: 'IMDB Rating: 8.30',
          duration: "2hrs 40mins",
          pg: '18',
          genre: 'Musical',
          price: 15.4),
      Movie(
          id: 'Quiet',
          name: 'A QUIET PLACE',
          description:
              'A family struggles for survival in a world invaded by blind alien creatures with ultra-sensitive hearing.',
          showingDateTime: 'Sunday 1st Nov, 2026 13:15PM',
          imagePath: 'assets/images/Quiet.jpeg',
          rating: 'IMDB Rating: 7.50',
          duration: '1hr 30mins',
          pg: 'PG',
          genre: 'Horror',
          price: 7.65)
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }
    return null;
  }

  Future<List<Movie>> loadMoviesFromAsset({
    String assetPath = 'assets/data/movies.json',
  }) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    final dynamic decodedStuff = jsonDecode(jsonString);
    final List<dynamic> jsonList = decodedStuff as List<dynamic>;
    final List<Movie> loadedMovies = [];

    for (final dynamic mov in jsonList) {
      final Map<String, dynamic> movieMap = mov as Map<String, dynamic>;
      final Movie movie = Movie.fromJson(movieMap);
      loadedMovies.add(movie);
    }
    _cachedMovies = loadedMovies;
    return loadedMovies;
  }

  Movie? getMovieByAgeRating(String rating) {
    for (final movie in getMovies()) {
      if (movie.pg == rating) {
        return movie;
      }
    }
    return null;
  }

  Movie? getMoviesUnderPrice(double maxPrice) {
    for (final movie in getMovies()) {
      if (movie.price < maxPrice) {
        return movie;
      }
    }
    return null;
  }
}
