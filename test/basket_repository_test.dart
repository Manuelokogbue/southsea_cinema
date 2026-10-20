import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/models/basket_item.dart';

const Movie testMovie1 = Movie(id: 'Anna', name: 'Annabelle', description: 'Test description', showingDateTime: 'Sometime soon', imagePath: 'assets/images/Annabelle.jpeg', rating: '8.9', duration: 'Duration', pg: 'PG', genre: 'Horror', price: 7.60);

const Movie testMovie2 = Movie(id: 'Ham', name: 'Hamilton', description: 'Test Ham', showingDateTime: '1807', imagePath: 'assets/images/Hamilton.jpeg', rating: '9.6', duration: '200', pg: '18', genre: 'Musical', price: 15.40);

void main() {
  setUp(() {
    BasketRepository.instance.empty();
  });

  group('BasketRepository tests', () {
  test('Initialise with empty repository', () {
    final BasketRepository basket = BasketRepository.instance;

    expect(basket.getMovies().length, 0);
    expect(basket.getTotalMovies(), 0);
    expect(basket.numberOfMovies, 0);
    expect(basket.getSurcharge(), 0.0);
    expect(basket.getAmountDue(), 0.0);
    expect(basket.getMovieTotal(), 0.0);
  });

  test('Adds movies and calculate movie total and fees', () {
    final BasketRepository basket = BasketRepository.instance;
    const BasketItem movie1 = BasketItem(movie: testMovie1, quantity: 2);
    const BasketItem movie2 = BasketItem(movie: testMovie2, quantity: 4);

    basket.addMovie(movie1);
    basket.addMovie(movie2);

    expect(basket.getMovies().length, 2);
    expect(basket.getTotalMovies(), 6);
    expect(basket.getMovieTotal(), 76.8);
    expect(basket.getSurcharge(), 4);
  });

  test('removes movies', () {
    final BasketRepository basket = BasketRepository.instance;

    const BasketItem movie = BasketItem(movie: testMovie1, quantity: 2);
    basket.addMovie(movie);
    expect(basket.getMovies().length, 1);

    basket.removeMovie(0);
    expect(basket.getMovies().length, 0);
    expect(basket.getAmountDue(), 0.0);
  });
});
}


