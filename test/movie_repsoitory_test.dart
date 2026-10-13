import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('MovieRepository unit tests', () {
    test('getMovies returns two movies', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      expect(movies.length, 3);
    });

    test('getMovies conrtain valid movies', () {
      final MovieRepository repository = MovieRepository();
      final List<Movie> movies = repository.getMovies();

      final Movie anna = movies[0];
      expect(anna.id, 'Anna');
      expect(anna.name, 'ANNABELLE');
      expect(anna.price, 9.5);
      expect(anna.pg, '18');

      final Movie hamil = movies[1];
      expect(hamil.id, 'Hamil');
      expect(hamil.name, 'HAMILTON');
      expect(hamil.price, 15.4);
      expect(hamil.pg, '18');
    });

    test('getMovieById rteurns a macthing movie when id exists', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('Anna');

      expect(movie, isNotNull);
      expect(movie?.name, 'ANNABELLE');
      expect(movie?.price, 9.5);
    });

    test('getMovieById returns null when invalid id is entered', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieById('Yam');

      expect(movie, isNull);
    });

    test('getMoviesByAgeRating returns nvalid movies with given age rating',
        () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMovieByAgeRating('PG');

      expect(movie?.id, 'Quiet');
      expect(movie?.name, 'A QUIET PLACE');
      expect(movie?.price, 7.65);
    });

    test('getMoviesUnderPrice returns movies under the specified price', () {
      final MovieRepository repository = MovieRepository();
      final Movie? movie = repository.getMoviesUnderPrice(8);

      expect(movie?.id, 'Quiet');
      expect(movie?.name, 'A QUIET PLACE');
      expect(movie?.price, 7.65);
    });
  });
}
