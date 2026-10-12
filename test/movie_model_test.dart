import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('Creates Movie instance with given details', () {
      const movie = Movie(
          id: 'Wed',
          name: 'Wednesday',
          description:
              'Discover the mysteries of the unknown land with Wednesday Addams',
          showingDateTime: 'Friday 30th OCt, 2026 16:45PM',
          imagePath: 'assets/images/Annabelle',
          rating: '8.90',
          duration: '1hr 55mins',
          pg: 'PG',
          genre: 'Horror',
          price: 8.67);

      expect(movie.id, 'Wed');
      expect(movie.name, 'Wednesday');
      expect(movie.description,
          'Discover the mysteries of the unknown land with Wednesday Addams');
      expect(movie.showingDateTime, 'Friday 30th OCt, 2026 16:45PM');
      expect(movie.imagePath, 'assets/images/Annabelle');
      expect(movie.rating, '8.90');
      expect(movie.duration, '1hr 55mins');
      expect(movie.pg, 'PG');
      expect(movie.genre, 'Horror');
      expect(movie.price, 8.67);
    });

    test('formattedPrice gives the price of the movie to 2 decimal places', () {
      const movie = Movie(
          id: 'Wed',
          name: 'Wednesday',
          description:
              'Discover the mysteries of the unknown land with Wednesday Addams',
          showingDateTime: 'Friday 30th OCt, 2026 16:45PM',
          imagePath: 'assets/images/Annabelle',
          rating: '8.90',
          duration: '1hr 55mins',
          pg: 'PG',
          genre: 'Horror',
          price: 6.2);

      expect(movie.formattedPrice, '£6.20');
    });
    test('isChildFriendly returns appropriate bool value', () {
      const movie = Movie(
          id: 'Wed',
          name: 'Wednesday',
          description:
              'Discover the mysteries of the unknown land with Wednesday Addams',
          showingDateTime: 'Friday 30th OCt, 2026 16:45PM',
          imagePath: 'assets/images/Annabelle',
          rating: '8.90',
          duration: '1hr 55mins',
          pg: 'PG',
          genre: 'Horror',
          price: 6.2);

      expect(movie.isChildFriendly, true);
    });

    test('isAdultOnly returns appropriate bool value', () {
      const movie = Movie(
          id: 'Wed',
          name: 'Wednesday',
          description:
              'Discover the mysteries of the unknown land with Wednesday Addams',
          showingDateTime: 'Friday 30th OCt, 2026 16:45PM',
          imagePath: 'assets/images/Annabelle',
          rating: '8.90',
          duration: '1hr 55mins',
          pg: '17',
          genre: 'Horror',
          price: 6.2);

      expect(movie.isAdultOnly, false);
    });

  });
}
