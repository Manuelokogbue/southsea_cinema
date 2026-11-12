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

    test('JSON conversion works with every movie field', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': "Anna",
        "name": "ANNABELLE",
        "description":
            "A couple begins to experience terrifying supernatural occurrences involving a vintage doll shortly after their home is invaded by satanic cultists.",
        "showingDateTime": "Friday 30th Oct, 2026 12:00PM",
        "imagePath": "assets/images/Annabelle.jpeg",
        "rating": "IMDB Rating: 7.67",
        "duration": "2hrs 45mins",
        "pg": "18",
        "genre": "Horror",
        "price": 9.5
      };

      final Movie movie = Movie.fromJson(data);
      expect(movie.id, 'Anna');
      expect(movie.name, 'ANNABELLE');
      expect(movie.description,
          "A couple begins to experience terrifying supernatural occurrences involving a vintage doll shortly after their home is invaded by satanic cultists.");
      expect(movie.showingDateTime, "Friday 30th Oct, 2026 12:00PM");
      expect(movie.duration, "2hrs 45mins");
      expect(movie.imagePath, "assets/images/Annabelle.jpeg");
      expect(movie.price, 9.5);
      expect(movie.genre, 'Horror');
      expect(movie.rating, "IMDB Rating: 7.67");
    });

    test('fromJson accepts whole number price', () {
      final Map<String, dynamic> data = <String, dynamic>{
        'id': 'Wed',
        'name': 'Wednesday',
        'description':
            'Discover the mysteries of the unknown land with Wednesday Addams',
        'showingDateTime': 'Friday 30th OCt, 2026 16:45PM',
        'imagePath': 'assets/images/Annabelle',
        'rating': '8.90',
        'duration': '1hr 55mins',
        'pg': 'PG',
        'genre': 'Horror',
        'price': 6
      };
      final Movie movie = Movie.fromJson(data);

      expect(movie.price, 6.0);
      expect(movie.price, isA<double>());
    });
  });
}
